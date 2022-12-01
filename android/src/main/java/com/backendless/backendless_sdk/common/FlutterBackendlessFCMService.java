package com.backendless.backendless_sdk.common;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.app.RemoteInput;
import androidx.annotation.NonNull;

import com.backendless.Backendless;
import com.backendless.ContextHandler;
import com.backendless.async.callback.AsyncCallback;
import com.backendless.exceptions.BackendlessFault;
import com.backendless.messaging.Action;
import com.backendless.messaging.AndroidPushTemplate;
import com.backendless.messaging.PublishOptions;
import com.backendless.push.BackendlessFCMService;
import com.backendless.push.PushTemplateHelper;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;


import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;
import io.flutter.plugin.common.MethodChannel;

public class FlutterBackendlessFCMService extends FirebaseMessagingService {
    private static MethodChannel channel;

    private static final String IMMEDIATE_MESSAGE = "ImmediateMessage";
    private static final String TAG = FlutterBackendlessFCMService.class.getSimpleName();
    private static AtomicInteger notificationIdGenerator;

    public FlutterBackendlessFCMService()
    {
        if( FlutterBackendlessFCMService.notificationIdGenerator == null )
            FlutterBackendlessFCMService.notificationIdGenerator = new AtomicInteger( Backendless.getNotificationIdGeneratorInitValue() );
    }

    @Override
    public final void onNewToken( String token )
    {
        super.onNewToken( token );
        Context appContext = ContextHandler.getAppContext();
        this.refreshTokenOnBackendless( appContext, token );
    }

    @Override
    public final void onMessageReceived( RemoteMessage remoteMessage )
    {
        Intent msgIntent = remoteMessage.toIntent();
        Context appContext = ContextHandler.getAppContext();

        this.handleMessage( appContext, msgIntent );
    }

    @Override
    public void onDeletedMessages()
    {
        super.onDeletedMessages();
        Log.w( TAG, "there are too many messages (>100) pending for this app or your device hasn't connected to FCM in more than one month." );
    }

    private void handleMessage( final Context context, Intent intent )
    {
        int notificationId = FlutterBackendlessFCMService.notificationIdGenerator.getAndIncrement();
        Backendless.saveNotificationIdGeneratorState( FlutterBackendlessFCMService.notificationIdGenerator.get() );

        try
        {
            AndroidPushTemplate androidPushTemplate = null;

            String immediatePush = intent.getStringExtra( PublishOptions.ANDROID_IMMEDIATE_PUSH );
            if( immediatePush != null )
            {
                androidPushTemplate = (AndroidPushTemplate) weborb.util.io.Serializer.fromBytes( immediatePush.getBytes(), weborb.util.io.Serializer.JSON, false );
                androidPushTemplate.setName( FlutterBackendlessFCMService.IMMEDIATE_MESSAGE );
            }

            final String templateName = intent.getStringExtra( PublishOptions.TEMPLATE_NAME );
            if( immediatePush == null && templateName != null )
            {
                androidPushTemplate = PushTemplateHelper.getPushNotificationTemplates().get( templateName );
            }

            if( androidPushTemplate != null )
            {
                handleMessageWithTemplate( context, intent, androidPushTemplate, notificationId );
                return;
            }

            if( !this.onMessage( context, intent ) )
                return;

            final String message = intent.getStringExtra( PublishOptions.MESSAGE_TAG );
            final String contentTitle = intent.getStringExtra( PublishOptions.ANDROID_CONTENT_TITLE_TAG );
            final String summarySubText = intent.getStringExtra( PublishOptions.ANDROID_SUMMARY_SUBTEXT_TAG );
            String soundResource = intent.getStringExtra( PublishOptions.ANDROID_CONTENT_SOUND_TAG );
            fallBackMode( context, message, contentTitle, summarySubText, soundResource, intent.getExtras(), notificationId );
        }
        catch( Throwable throwable )
        {
            Log.e( TAG, "Error processing push notification", throwable );
        }
    }

    private void handleMessageWithTemplate( final Context context, Intent intent, AndroidPushTemplate androidPushTemplate, final int notificationId )
    {
        Bundle newBundle = prepareMessageBundle( intent.getExtras(), androidPushTemplate, notificationId );

        Intent newMsgIntent = new Intent();
        newMsgIntent.putExtras( newBundle );

        if( !this.onMessage( context, newMsgIntent ) )
            return;

        if( androidPushTemplate.getContentAvailable() != null && androidPushTemplate.getContentAvailable() == 1 )
            return;

        Notification notification = FlutterBackendlessFCMService.convertFromTemplate( context, androidPushTemplate, newBundle, notificationId );
        FlutterBackendlessFCMService.showNotification( context, notification, androidPushTemplate.getName(), notificationId );
    }

    static Bundle prepareMessageBundle(final Bundle rawMessageBundle, final AndroidPushTemplate template, final int notificationId )
    {
        Bundle newBundle = new Bundle( );

        if( template.getCustomHeaders() != null && !template.getCustomHeaders().isEmpty() )
        {
            for( Map.Entry<String, String> header : template.getCustomHeaders().entrySet() )
                newBundle.putString( header.getKey(), header.getValue() );
        }

        newBundle.putAll( rawMessageBundle );

        String contentTitle = rawMessageBundle.getString( PublishOptions.ANDROID_CONTENT_TITLE_TAG );
        String summarySubText = rawMessageBundle.getString( PublishOptions.ANDROID_SUMMARY_SUBTEXT_TAG );

        contentTitle = contentTitle != null ? contentTitle : template.getContentTitle();
        summarySubText = summarySubText != null ? summarySubText : template.getSummarySubText();

        newBundle.putString( PublishOptions.ANDROID_CONTENT_TITLE_TAG, contentTitle );
        newBundle.putString( PublishOptions.ANDROID_SUMMARY_SUBTEXT_TAG, summarySubText );
        newBundle.putInt( PublishOptions.NOTIFICATION_ID, notificationId );
        newBundle.putString( PublishOptions.TEMPLATE_NAME, template.getName() );

        return newBundle;
    }

    @SuppressLint("RestrictedApi")
    @SuppressWarnings("deprecation")
    static Notification convertFromTemplate(final Context context, final AndroidPushTemplate template, final Bundle newBundle, int notificationId )
    {
        Context appContext = context.getApplicationContext();
        // Notification channel ID is ignored for Android 7.1.1 (API level 25) and lower.

        String messageText = newBundle.getString( PublishOptions.MESSAGE_TAG );

        String contentTitle = newBundle.getString( PublishOptions.ANDROID_CONTENT_TITLE_TAG );
        contentTitle = contentTitle != null ? contentTitle : template.getContentTitle();

        String summarySubText = newBundle.getString( PublishOptions.ANDROID_SUMMARY_SUBTEXT_TAG );
        summarySubText = summarySubText != null ? summarySubText : template.getSummarySubText();

        String largeIcon = newBundle.getString( PublishOptions.ANDROID_LARGE_ICON_TAG );
        largeIcon = largeIcon != null ? largeIcon : template.getLargeIcon();

        String attachmentUrl = newBundle.getString( PublishOptions.ANDROID_ATTACHMENT_URL_TAG );
        attachmentUrl = attachmentUrl != null ? attachmentUrl : template.getAttachmentUrl();


        NotificationCompat.Builder notificationBuilder;
        // android.os.Build.VERSION_CODES.O == 26
        if( android.os.Build.VERSION.SDK_INT > 25 )
        {
            NotificationChannel notificationChannel = getOrCreateNotificationChannel( appContext, template );
            notificationBuilder = new NotificationCompat.Builder( appContext, notificationChannel.getId() );

            if( template.getBadge() != null &&
                    ( template.getBadge() == NotificationCompat.BADGE_ICON_SMALL || template.getBadge() == NotificationCompat.BADGE_ICON_LARGE ) )
                notificationBuilder.setBadgeIconType( template.getBadge() );
            else
                notificationBuilder.setBadgeIconType( NotificationCompat.BADGE_ICON_NONE );

            if( template.getBadgeNumber() != null )
                notificationBuilder.setNumber( template.getBadgeNumber() );

            if( template.getCancelAfter() != null && template.getCancelAfter() != 0 )
                notificationBuilder.setTimeoutAfter( template.getCancelAfter()*1000 );
        }
        else
        {
            notificationBuilder = new NotificationCompat.Builder( appContext );

            if( template.getPriority() != null && template.getPriority() > 0 && template.getPriority() < 6 )
                notificationBuilder.setPriority( template.getPriority() - 3 );
            else
                notificationBuilder.setPriority( NotificationCompat.PRIORITY_DEFAULT );

            if( notificationBuilder.getPriority() > NotificationCompat.PRIORITY_LOW )
                notificationBuilder.setSound( FlutterBackendlessFCMService.getSoundUri( appContext, template.getSound() ), AudioManager.STREAM_NOTIFICATION );

            if( template.getVibrate() != null && template.getVibrate().length > 0 && notificationBuilder.getPriority() > NotificationCompat.PRIORITY_LOW )
            {
                long[] vibrate = new long[ template.getVibrate().length ];
                int index = 0;
                for( long l : template.getVibrate() )
                    vibrate[ index++ ] = l;

                notificationBuilder.setVibrate( vibrate );
            }
        }

        if( attachmentUrl != null )
        {
            try
            {
                InputStream is = (InputStream) new URL( attachmentUrl ).getContent();
                Bitmap bitmap = BitmapFactory.decodeStream( is );

                if( bitmap != null )
                    notificationBuilder.setStyle( new NotificationCompat.BigPictureStyle().bigPicture( bitmap ) );
                else
                    Log.i( PushTemplateHelper.class.getSimpleName(), "Cannot convert rich media for notification into bitmap." );
            }
            catch( IOException e )
            {
                Log.e( PushTemplateHelper.class.getSimpleName(), "Cannot receive rich media for notification." );
            }
        }
        else if( messageText.length() > 35 )
        {
            NotificationCompat.BigTextStyle bigText = new NotificationCompat.BigTextStyle()
                    .setBigContentTitle( contentTitle )
                    .setSummaryText( summarySubText )
                    .bigText( messageText );
            notificationBuilder.setStyle( bigText );
        }

        if( largeIcon != null )
        {
            if (largeIcon.startsWith( "http" ))
            {
                try
                {
                    InputStream is = (InputStream) new URL( largeIcon ).getContent();
                    Bitmap bitmap = BitmapFactory.decodeStream( is );

                    if( bitmap != null )
                        notificationBuilder.setLargeIcon( bitmap );
                    else
                        Log.i( PushTemplateHelper.class.getSimpleName(), "Cannot convert Large Icon into bitmap." );
                }
                catch( IOException e )
                {
                    Log.e( PushTemplateHelper.class.getSimpleName(), "Cannot receive bitmap for Large Icon." );
                }
            }
            else
            {
                int largeIconResource = appContext.getResources().getIdentifier( largeIcon, "drawable", appContext.getPackageName() );
                if (largeIconResource != 0)
                {
                    Bitmap bitmap = BitmapFactory.decodeResource(appContext.getResources(), largeIconResource);
                    notificationBuilder.setLargeIcon( bitmap );
                }
            }
        }

        int icon = 0;

        // try to get icon from template
        if( template.getIcon() != null )
        {
            icon = appContext.getResources().getIdentifier( template.getIcon(), "mipmap", appContext.getPackageName() );

            if( icon == 0 )
                icon = appContext.getResources().getIdentifier( template.getIcon(), "drawable", appContext.getPackageName() );
        }

        // try to get default icon
        if( icon == 0 )
        {
            icon = context.getApplicationInfo().icon;
            if( icon == 0 )
                icon = android.R.drawable.sym_def_app_icon;
        }

        if( icon != 0 )
            notificationBuilder.setSmallIcon( icon );

        if (template.getLightsColor() != null && template.getLightsOnMs() != null && template.getLightsOffMs() != null)
            notificationBuilder.setLights(template.getLightsColor()|0xFF000000, template.getLightsOnMs(), template.getLightsOffMs());

        if (template.getColorCode() != null)
            notificationBuilder.setColor( template.getColorCode()|0xFF000000 );

        if (template.getCancelOnTap() != null)
            notificationBuilder.setAutoCancel( template.getCancelOnTap() );
        else
            notificationBuilder.setAutoCancel( false );

        notificationBuilder
                .setShowWhen( true )
                .setWhen( System.currentTimeMillis() )
                .setContentTitle( contentTitle != null ? contentTitle : template.getContentTitle() )
                .setSubText( summarySubText != null ? summarySubText : template.getSummarySubText() )
                .setContentText( messageText );

        Intent notificationIntent;
        if (template.getActionOnTap() == null || template.getActionOnTap().isEmpty())
            notificationIntent = appContext.getPackageManager().getLaunchIntentForPackage(appContext.getPackageName());
        else
        {
            notificationIntent = new Intent("ActionOnTap");
            notificationIntent.setClassName(appContext, template.getActionOnTap());
        }

        notificationIntent.putExtras(newBundle);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);


        //TODO : NEED REPLACE WITH THIS???: PendingIntent.getActivity(
        //            context, notificationId * 3, notificationIntent, PendingIntent.FLAG_IMMUTABLE );
        PendingIntent contentIntent = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            contentIntent = PendingIntent.getActivity
                    (appContext, notificationId * 3, notificationIntent, PendingIntent.FLAG_MUTABLE);
        }
        else
        {
            contentIntent = PendingIntent.getActivity
                    (appContext, notificationId * 3, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        }

        // user should use messageId and tag(templateName) to cancel notification.
        notificationBuilder.setContentIntent(contentIntent);

        if( template.getActions() != null )
        {
            List<NotificationCompat.Action> actions = createActions( appContext, template.getActions(), newBundle, notificationId );
            for( NotificationCompat.Action action : actions )
                notificationBuilder.addAction( action );
        }

        return notificationBuilder.build();
    }

    static private List<NotificationCompat.Action> createActions(final Context appContext, final Action[] actions, final Bundle bundle, int notificationId )
    {
        List<NotificationCompat.Action> notifActions = new ArrayList<>();

        int i = 1;
        for( Action a : actions )
        {
            Intent actionIntent = new Intent( a.getTitle() );
            actionIntent.setClassName( appContext, a.getId() );
            actionIntent.putExtras( bundle );
            actionIntent.setFlags( Intent.FLAG_ACTIVITY_NEW_TASK );

            // user should use messageId and tag(templateName) to cancel notification.

            PendingIntent pendingIntent = PendingIntent.getActivity( appContext, notificationId * 3 + i++, actionIntent, PendingIntent.FLAG_UPDATE_CURRENT );

            NotificationCompat.Action.Builder actionBuilder = new NotificationCompat.Action.Builder( 0, a.getTitle(), pendingIntent );

            if( a.getOptions() == 1 )
            {
                RemoteInput remoteInput = new RemoteInput.Builder( PublishOptions.INLINE_REPLY ).build();
                actionBuilder.setAllowGeneratedReplies( true ).addRemoteInput( remoteInput );
            }
            notifActions.add( actionBuilder.build() );
        }

        return notifActions;
    }

    static Uri getSoundUri(Context context, String resource )
    {
        Uri soundUri;
        if( resource != null && !resource.isEmpty() )
        {
            int soundResource = context.getResources().getIdentifier( resource, "raw", context.getPackageName() );
            soundUri = Uri.parse( "android.resource://" + context.getPackageName() + "/" + soundResource );
        }
        else
            soundUri = RingtoneManager.getDefaultUri( RingtoneManager.TYPE_NOTIFICATION );

        return soundUri;
    }


    static public NotificationChannel getOrCreateNotificationChannel( Context context, final AndroidPushTemplate template )
    {
        final String channelId = getChannelId( template.getName() );
        NotificationManager notificationManager = (NotificationManager) context.getSystemService( Context.NOTIFICATION_SERVICE );

        NotificationChannel notificationChannel = notificationManager.getNotificationChannel( channelId );

        if( notificationChannel != null )
            return notificationChannel;

        notificationChannel = new NotificationChannel( channelId, template.getName(), NotificationManager.IMPORTANCE_DEFAULT );
        updateNotificationChannel( context, notificationChannel, template );
        notificationManager.createNotificationChannel( notificationChannel );
        return notificationChannel;
    }

    static private NotificationChannel updateNotificationChannel( Context context, NotificationChannel notificationChannel, final AndroidPushTemplate template )
    {
        if( template.getShowBadge() != null )
            notificationChannel.setShowBadge( template.getShowBadge() );

        if( template.getPriority() != null && template.getPriority() > 0 && template.getPriority() < 6 )
            notificationChannel.setImportance( template.getPriority() ); // NotificationManager.IMPORTANCE_DEFAULT

        AudioAttributes audioAttributes = new AudioAttributes.Builder()
                .setUsage( AudioAttributes.USAGE_NOTIFICATION_RINGTONE )
                .setContentType( AudioAttributes.CONTENT_TYPE_SONIFICATION )
                .setFlags( AudioAttributes.FLAG_AUDIBILITY_ENFORCED )
                .setLegacyStreamType( AudioManager.STREAM_NOTIFICATION )
                .build();

        notificationChannel.setSound( getSoundUri( context, template.getSound() ), audioAttributes );

        if (template.getLightsColor() != null)
        {
            notificationChannel.enableLights( true );
            notificationChannel.setLightColor( template.getLightsColor()|0xFF000000 );
        }

        if( template.getVibrate() != null && template.getVibrate().length > 0 )
        {
            long[] vibrate = new long[ template.getVibrate().length ];
            int index = 0;
            for( long l : template.getVibrate() )
                vibrate[ index++ ] = l;

            notificationChannel.enableVibration( true );
            notificationChannel.setVibrationPattern( vibrate );
        }

        return notificationChannel;
    }

    static String getChannelId( String channelName )
    {
        return getChannelNotificationPrefix() + ":" + channelName;
    }

    static private String getChannelNotificationPrefix()
    {
        return Backendless.getApplicationIdOrDomain();
    }

    static void showNotification( final Context context, final Notification notification, final String tag, final int notificationId )
    {
        final NotificationManagerCompat notificationManager = NotificationManagerCompat.from( context.getApplicationContext() );
        Handler handler = new Handler( Looper.getMainLooper() );
        handler.post( new Runnable()
        {
            @Override
            public void run()
            {
                notificationManager.notify( tag, notificationId, notification );
            }
        } );
    }

    private void refreshTokenOnBackendless( final Context context, String newDeviceToken )
    {
        Backendless.Messaging.refreshDeviceToken( newDeviceToken, new AsyncCallback<Boolean>()
        {
            @Override
            public void handleResponse( Boolean response )
            {
                if( response )
                    Log.d( TAG, "Device token refreshed successfully." );
                else
                {
                    Log.d( TAG, "Device is not registered on any channel." );
                    FlutterBackendlessFCMService.unregisterDeviceOnFCM( context, null );
                }
            }

            @Override
            public void handleFault( BackendlessFault fault )
            {
                Log.e( TAG, "Can not refresh device token on Backendless. " + fault.getMessage() );
            }
        } );
    }

    static void unregisterDeviceOnFCM(final Context context, final AsyncCallback<Integer> callback)
    {
        FirebaseMessaging.getInstance().unsubscribeFromTopic( "default-topic" ).addOnCompleteListener(new OnCompleteListener<Void>()
        {
            @Override
            public void onComplete( @NonNull Task<Void> task )
            {
                if( task.isSuccessful() )
                {
                    Log.d( TAG, "Unsubscribed on FCM." );
                    if( callback != null )
                        callback.handleResponse( 0 );
                }
                else
                {
                    Log.e( TAG, "Failed to unsubscribe in FCM.", task.getException() );
                    String reason = (task.getException() != null) ? Objects.toString( task.getException().getMessage() ) : "";
                    if( callback != null )
                        callback.handleFault( new BackendlessFault( "Failed to unsubscribe on FCM. " + reason ) );
                }
            }
        } );
    }

    private void fallBackMode( Context context, String message, String contentTitle, String summarySubText, String soundResource, Bundle bundle, final int notificationId )
    {
        final String channelName = "Fallback";
        final NotificationCompat.Builder notificationBuilder;
        Bundle newBundle = new Bundle();
        newBundle.putAll( bundle );
        newBundle.putInt( PublishOptions.NOTIFICATION_ID, notificationId );

        // android.os.Build.VERSION_CODES.O == 26
        if( android.os.Build.VERSION.SDK_INT > 25 )
        {
            final String channelId = getChannelId( channelName );
            NotificationManager notificationManager = (NotificationManager) context.getSystemService( Context.NOTIFICATION_SERVICE );
            NotificationChannel notificationChannel = notificationManager.getNotificationChannel( channelId );

            if( notificationChannel == null )
            {
                notificationChannel = new NotificationChannel( channelId, channelName, NotificationManager.IMPORTANCE_DEFAULT );

                AudioAttributes audioAttributes = new AudioAttributes.Builder()
                        .setUsage( AudioAttributes.USAGE_NOTIFICATION_RINGTONE )
                        .setContentType( AudioAttributes.CONTENT_TYPE_SONIFICATION )
                        .setFlags( AudioAttributes.FLAG_AUDIBILITY_ENFORCED )
                        .setLegacyStreamType( AudioManager.STREAM_NOTIFICATION )
                        .build();

                notificationChannel.setSound( getSoundUri( context, soundResource ), audioAttributes );
                notificationManager.createNotificationChannel( notificationChannel );
            }

            notificationBuilder = new NotificationCompat.Builder( context, notificationChannel.getId() );
        }
        else
            notificationBuilder = new NotificationCompat.Builder( context );

        notificationBuilder.setSound( getSoundUri( context, soundResource ), AudioManager.STREAM_NOTIFICATION );

        int appIcon = context.getApplicationInfo().icon;
        if( appIcon == 0 )
            appIcon = android.R.drawable.sym_def_app_icon;

        Intent notificationIntent = context.getPackageManager().getLaunchIntentForPackage( context.getApplicationInfo().packageName );
        notificationIntent.putExtras( newBundle );
        PendingIntent contentIntent = PendingIntent.getActivity(
                context, notificationId * 3, notificationIntent, PendingIntent.FLAG_IMMUTABLE );

        notificationBuilder.setContentIntent( contentIntent )
                .setSmallIcon( appIcon )
                .setContentTitle( contentTitle )
                .setSubText( summarySubText )
                .setContentText( message )
                .setWhen( System.currentTimeMillis() )
                .setAutoCancel( true )
                .build();

        final NotificationManagerCompat notificationManager = NotificationManagerCompat.from( context );
        Handler handler = new Handler( Looper.getMainLooper() );
        handler.post( new Runnable()
        {
            @Override
            public void run()
            {
                notificationManager.notify( channelName, notificationId, notificationBuilder.build() );
            }
        } );
    }

    public boolean onMessage( Context appContext, Intent msgIntent )
    {
        if (channel != null && msgIntent != null) {
            new Handler(getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    channel.invokeMethod("onMessage", bundleToMap(msgIntent.getExtras()));
                }
            });
        }

        return true;
    }

    public static void setMethodChannel(MethodChannel methodChannel) {
        channel = methodChannel;
    }

    public Map<String, Object> bundleToMap(Bundle extras) {
        Map<String, Object> map = new HashMap<>();
        for (String key : extras.keySet()) {
            map.put(key, extras.get(key));
        }
        return map;
    }
}
