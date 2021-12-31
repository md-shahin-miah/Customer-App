package uk.co.ordervox.merchant;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.speech.tts.TextToSpeech;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkError;
import com.android.volley.NoConnectionError;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.ServerError;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;

import org.apache.http.conn.ConnectTimeoutException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParserException;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ConnectException;
import java.net.MalformedURLException;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;


public class MyService extends Service {

    private static final String TAG = "MainActivity";
    MediaPlayer m;


    private Handler mHandler = new Handler();
    public static long NOTIFY_INTERVAL = 15 * 1000; // 15 sec
    TextToSpeech t1;
    TextToSpeech t2;

    // timer handling
    private Timer mTimer = null;

    public static String url;

    int playSoundCount = 0;

    int awaitingCounter = 0;

    int counter = 0;

    @Override
    public void onCreate() {
        super.onCreate();


        t1 = new TextToSpeech(getApplicationContext(), new TextToSpeech.OnInitListener() {
            @Override
            public void onInit(int status) {
                if (status != TextToSpeech.ERROR) {
                    t1.setLanguage(Locale.UK);
                }
            }
        });
        t2 = new TextToSpeech(getApplicationContext(), new TextToSpeech.OnInitListener() {
            @Override
            public void onInit(int status) {
                if (status != TextToSpeech.ERROR) {
                    t2.setLanguage(Locale.UK);
                }
            }
        });


        if (mTimer != null) {
            mTimer.cancel();
        } else {
            // recreate new
            mTimer = new Timer();
        }
        // schedule task
        mTimer.scheduleAtFixedRate(new TimeDisplayTimerTask(), 0, NOTIFY_INTERVAL);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "messages")
                    .setContentText("This is running in Background")
                    .setContentTitle("OrderE - Merchant App is running in background")
                    .setSmallIcon(R.drawable.logo);
            startForeground(101, builder.build());
        }

    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    class TimeDisplayTimerTask extends TimerTask {
        OutputStreamWriter outputStreamWriter;

        // write text to file
        public void writeToFile(String data, int type) {
            try {
                if (type == 3) {
                    outputStreamWriter = new OutputStreamWriter(openFileOutput("settings_status.txt", Context.MODE_PRIVATE));
                } else if (type == 2) {
                    outputStreamWriter = new OutputStreamWriter(openFileOutput("configBooking.txt", Context.MODE_PRIVATE));
                } else {
                    outputStreamWriter = new OutputStreamWriter(openFileOutput("config.txt", Context.MODE_PRIVATE));

                }
                outputStreamWriter.write(data);
                outputStreamWriter.close();
            } catch (IOException e) {
                Log.e("Exception", "File write failed: " + e.toString());
            }
        }


        public String readFromFile() {

            String ret = "";

            try {
                InputStream inputStream = getApplicationContext().openFileInput("audio.txt");

                if (inputStream != null) {
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                    String receiveString = "";
                    StringBuilder stringBuilder = new StringBuilder();

                    while ((receiveString = bufferedReader.readLine()) != null) {
                        stringBuilder.append(receiveString);
                    }

                    inputStream.close();
                    ret = stringBuilder.toString();
                }
            } catch (FileNotFoundException e) {
                Log.e("login activity", "File not found: " + e.toString());
            } catch (IOException e) {
                Log.e("login activity", "Can not read file: " + e.toString());
            }

            return ret;
        }

        public String readFromFilePrinter() {

            String ret = "";

            try {
                InputStream inputStream = getApplicationContext().openFileInput("printer.txt");

                if (inputStream != null) {
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                    String receiveString = "";
                    StringBuilder stringBuilder = new StringBuilder();

                    while ((receiveString = bufferedReader.readLine()) != null) {
                        stringBuilder.append(receiveString);
                    }

                    inputStream.close();
                    ret = stringBuilder.toString();
                }
            } catch (FileNotFoundException e) {
                Log.e("login activity", "File not found: " + e.toString());
            } catch (IOException e) {
                Log.e("login activity", "Can not read file: " + e.toString());
            }

            return ret;
        }

        public String readFromFileServerSpeak() {

            String ret = "";

            try {
                InputStream inputStream = getApplicationContext().openFileInput("server.txt");

                if (inputStream != null) {
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                    String receiveString = "";
                    StringBuilder stringBuilder = new StringBuilder();

                    while ((receiveString = bufferedReader.readLine()) != null) {
                        stringBuilder.append(receiveString);
                    }

                    inputStream.close();
                    ret = stringBuilder.toString();
                }
            } catch (FileNotFoundException e) {
                Log.e("login activity", "File not found: " + e.toString());
            } catch (IOException e) {
                Log.e("login activity", "Can not read file: " + e.toString());
            }

            return ret;
        }

        public String readFromFileAwaiting() {

            String ret = "";

            try {
                InputStream inputStream = getApplicationContext().openFileInput("awaiting.txt");

                if (inputStream != null) {
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                    String receiveString = "";
                    StringBuilder stringBuilder = new StringBuilder();

                    while ((receiveString = bufferedReader.readLine()) != null) {
                        stringBuilder.append(receiveString);
                    }

                    inputStream.close();
                    ret = stringBuilder.toString();
                }
            } catch (FileNotFoundException e) {
                Log.e("login activity", "File not found: " + e.toString());
            } catch (IOException e) {
                Log.e("login activity", "Can not read file: " + e.toString());
            }

            return ret;
        }


        void checkPendingOrder() {

            String version="";
            try {
                PackageInfo pInfo = getApplicationContext().getPackageManager().getPackageInfo(getApplicationContext().getPackageName(), 0);
           version = pInfo.versionName;

                android.util.Log.d(TAG, "checkPendingOrder:version "+version);
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            try {
                StringRequest stringRequest = new StringRequest(Request.Method.GET, "https://" + url + "/api/Merchant/getPendingOrders/"+version, new Response.Listener<String>() {
                    @SuppressLint("LongLogTag")
                    @Override
                    public void onResponse(String response) {
                        Log.e("id___response", "" + response.trim());


                        playSoundCount = 0;
                        awaitingCounter = 0;

                        try {
                            JSONArray ids = new JSONArray();
                            JSONArray bookingIds = new JSONArray();

                            JSONObject jsonObject = new JSONObject(response);

                            try {
                                int settings_status = jsonObject.getInt("settings_status");

                                android.util.Log.d(TAG, "onResponse: " + settings_status);

                                writeToFile(String.valueOf(settings_status), 3);
                            } catch (Exception e) {

                            }


                            JSONArray orders = jsonObject.getJSONArray("orders");

                            for (int i = 0; i < orders.length(); i++) {
                                JSONObject orderObj = orders.getJSONObject(i);
                                int orderId = orderObj.getInt("order_id");
                                int orderStatus = orderObj.getInt("order_status");
                                JSONObject jsonObj = new JSONObject();
                                if (orderStatus == 1) {
                                    jsonObj.put("id", "" + orderId);
                                    ids.put(jsonObj);
                                }

                                Log.d(TAG, "onResponse: $orderStatus-" + orderStatus);
                                if (orderStatus == 0) {
                                    awaitingCounter++;
                                }

                                Log.d("id___responsein order", "" + orderId);
                            }
                            if (ids.length() > 0) {
                                playSoundCount++;
                                writeToFile(ids.toString(), 1);
                            } else {
                                writeToFile("-1", 1);
                            }

                            JSONArray table_booking = jsonObject.getJSONArray("table_booking");
                            for (int i = 0; i < table_booking.length(); i++) {
                                JSONObject orderObj = table_booking.getJSONObject(i);
                                int orderId = orderObj.getInt("booking_table_id");
                                JSONObject jsonObj = new JSONObject();
                                jsonObj.put("id", "" + orderId);
                                bookingIds.put(jsonObj);
                                Log.d("id___responsein table_booking", "" + orderId);
                            }

                            if (table_booking.length() > 0) {
                                playSoundCount++;
                                writeToFile(bookingIds.toString(), 2);
                            } else {
                                writeToFile("-1", 2);
                            }
                            Log.d(TAG, "onResponse:  readFromFile" + readFromFile());

//                            if ((readFromFileAwaiting().equals("a"))){
//
//                                if (awaitingCounter==0 && ids.length==0){
//                                    if (playSoundCount>0){
//                                        playBeep("sound_awaiting.wav");
//                                    }
//                                }
//
//                            }
//                            if ((readFromFileAwaiting().equals("n"))){
//                                if (awaitingCounter==0 && ids.length==0){
//                                    if (playSoundCount>0){
//                                        playBeep("sound_notpaid.wav");
//                                    }
//                                }
//                            }
                            Log.d(TAG, "onResponse: is pcy data -- " + readFromFilePrinter());
                            if (readFromFilePrinter().equals("pcn")) {

                                t2.speak("Printer has been disconnected", TextToSpeech.QUEUE_ADD, null);
                            }

//
                            Log.d(TAG, "onResponse: readFile 'n' counter - " + awaitingCounter + "readFromFileAwaiting().equals(\"n\")-----" + readFromFileAwaiting().equals("n"));
                            Log.d(TAG, "onResponse: readFile 'a' counter - " + awaitingCounter + "readFromFileAwaiting().equals(\"n\")-----" + readFromFileAwaiting().equals("a"));


//                            if ((readFromFile().equals("1S") || readFromFile().equals("1M") || readFromFile().equals("1L")) && (readFromFileAwaiting().equals("n") || readFromFileAwaiting().equals("a"))) {
//
//
//                                Log.d(TAG, "onResponse: if----------");
//
//                                if (readFromFile().equals("1S")) {
//                                    Log.d(TAG, "onResponse: readFile 1S");
//
//                                    if (playSoundCount > 0) {
//                                        playBeep("sound_pending_short.wav");
//                                    }
//                                }
//                                if (readFromFile().equals("1M")) {
//                                    Log.d(TAG, "onResponse: readFile 1S");
//
//                                    if (playSoundCount > 0) {
//                                        playBeep("sound_pending_medium.wav");
//                                    }
//
//                                }
//                                if (readFromFile().equals("1L")) {
//                                    Log.d(TAG, "onResponse: readFile 1S");
//                                    if (playSoundCount > 0) {
//                                        playBeep("sound_pending_long.wav");
//                                    }
//
//                                } else {
//                                    Log.d(TAG, "onResponse: readFile else");
//
//                                }
//                            } else {

                                Log.d(TAG, "onResponse: else----------");

                                if (readFromFile().equals("1S")) {
                                    Log.d(TAG, "onResponse: readFile 1S");

                                    if (playSoundCount > 0) {
                                        playBeep("sound_pending_short.wav");
                                    }
                                }
                                if (readFromFile().equals("1M")) {
                                    Log.d(TAG, "onResponse: readFile 1M");

                                    if (playSoundCount > 0) {
                                        playBeep("sound_pending_medium.wav");
                                    }

                                }
                                if (readFromFile().equals("1L")) {
                                    Log.d(TAG, "onResponse: readFile 1L");
                                    if (playSoundCount > 0) {
                                        playBeep("sound_pending_long.wav");
                                    }

                                }
                                if (readFromFileAwaiting().equals("n")) {
                                    Log.d(TAG, "onResponse: readFile 'n' counter" + awaitingCounter + "readFromFileAwaiting().equals(\"n\")" + readFromFileAwaiting().equals("n"));

                                    if (awaitingCounter > 0) {
                                        playBeep("sound_notpaid.wav");
                                    }
                                }
                                if (readFromFileAwaiting().equals("a")) {
                                    Log.d(TAG, "onResponse: readFile 'a' counter" + awaitingCounter);

                                    if (awaitingCounter > 0) {
                                        Log.d(TAG, "onResponse: dhukche" + awaitingCounter);
                                        playBeep("sound_awaiting.wav");
                                    }
                                }

//                            }


//                            Toast.makeText(getApplicationContext(), "res:" +result, Toast.LENGTH_SHORT).show();
//                           for(int i=0; i<ids.length();i++){
//                                Log.e("id___",""+ids.get(i));
//                            }
                            PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0,
                                    new Intent(getApplicationContext(), MainActivity.class), 0);

                            NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), "messages")
                                    .setContentText("Printing service running on background")
                                    .setContentTitle("Service Running")
                                    .setSmallIcon(R.drawable.logo);
                            builder.setContentIntent(pendingIntent);

                            startForeground(101, builder.build());

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }


                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

//                        Log.d(TAG, "onErrorResponse: err:-   "+ error+" err msg " + error.getMessage() +   "  cz "+ error.getCause() +   " hhh---  " + readFromFileServerSpeak());


//                        if(error.getMessage().toLowerCase().contains("noconnectionerror")){
//
//                            Log.d(TAG, "onErrorResponse: noconnectionerror"+error.getMessage());
//                        }


                        if (readFromFileServerSpeak().equals("1")) {
                            if (error instanceof NoConnectionError) {
                                ConnectivityManager cm = (ConnectivityManager) getApplicationContext()
                                        .getSystemService(Context.CONNECTIVITY_SERVICE);
                                NetworkInfo activeNetwork = null;
                                if (cm != null) {
                                    activeNetwork = cm.getActiveNetworkInfo();
                                }
                                if (activeNetwork != null && activeNetwork.isConnectedOrConnecting()) {


                                    counter++;
                                    if (counter > 5) {
                                        //t1.speak("unable to established web communication", TextToSpeech.QUEUE_ADD, null);
                                        //Toast.makeText(getApplicationContext(), "unable to established web communication",
                                              //  Toast.LENGTH_SHORT).show();
                                    } else {
                                      //  t1.speak("Waiting for website response", TextToSpeech.QUEUE_ADD, null);
                                       // Toast.makeText(getApplicationContext(), "Waiting for website response",
                                              //  Toast.LENGTH_SHORT).show();
                                    }


                                } else {
                                    t1.speak(" Please check your internet connection.", TextToSpeech.QUEUE_ADD, null);
                                    Toast.makeText(getApplicationContext(), "Please check your internet connection.",
                                            Toast.LENGTH_SHORT).show();
                                }
                            }


//                            else if (error instanceof NetworkError || error.getCause() instanceof ConnectException
//                                    || (Objects.requireNonNull(error.getCause()).getMessage() != null
//                                    && error.getCause().getMessage().contains("connection"))) {
//                                t1.speak("Your device is not connected to internet.", TextToSpeech.QUEUE_ADD, null);
//                                Toast.makeText(getApplicationContext(), "Your device is not connected to internet.",
//                                        Toast.LENGTH_SHORT).show();
//                            }


                            else if (error.getCause() instanceof MalformedURLException) {
                               // Toast.makeText(getApplicationContext(), "Bad Request.", Toast.LENGTH_SHORT).show();
                            } else if (error instanceof ParseError || error.getCause() instanceof IllegalStateException
                                    || error.getCause() instanceof JSONException
                                    || error.getCause() instanceof XmlPullParserException) {
                              //  Toast.makeText(getApplicationContext(), "Parse Error (because of invalid json or xml).",
                                       // Toast.LENGTH_SHORT).show();
                            } else if (error.getCause() instanceof OutOfMemoryError) {
                                //Toast.makeText(getApplicationContext(), "Out Of Memory Error.", Toast.LENGTH_SHORT).show();
                            } else if (error instanceof AuthFailureError) {
                             //   t1.speak("server couldn't find the authenticated request.", TextToSpeech.QUEUE_ADD, null);
                               // Toast.makeText(getApplicationContext(), "server couldn't find the authenticated request.",
                                     //   Toast.LENGTH_SHORT).show();
                            } else if (error instanceof ServerError || error.getCause() instanceof ServerError) {
                           //     t1.speak("Server is not responding.", TextToSpeech.QUEUE_ADD, null);

                              //  Toast.makeText(getApplicationContext(), "Server is not responding.", Toast.LENGTH_SHORT).show();
                            }

//                            else if (error instanceof TimeoutError || error.getCause() instanceof SocketTimeoutException
//                                    || error.getCause() instanceof ConnectTimeoutException
//                                    || error.getCause() instanceof SocketException
//                                    || (error.getCause().getMessage() != null
//                                    && error.getCause().getMessage().contains("Connection timed out"))) {
//                                Toast.makeText(getApplicationContext(), "Connection timeout error",
//                                        Toast.LENGTH_SHORT).show();
//                                t1.speak("server Connection timeout ", TextToSpeech.QUEUE_ADD, null);
//
//                            }
                            else {
//                                t1.speak(" Please check your internet connection", TextToSpeech.QUEUE_ADD, null);
//
//                                Toast.makeText(getApplicationContext(), "An unknown error occurred.",
//                                        Toast.LENGTH_SHORT).show();
                            }
                        }

//                        if (error.toString().equals("com.android.volley.NoConnectionError:")){
//                            Log.d(TAG, "onErrorResponse: ifffff:-");
//
//                        }
//                        else{
//                            Log.d(TAG, "onErrorResponse: elseeeeee:-");
//
//                        }


//                        Toast.makeText(MyService.this, ""+error.getMessage(), Toast.LENGTH_SHORT).show();


                        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0,
                                new Intent(getApplicationContext(), MainActivity.class), 0);
                        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), "messages")
                                .setContentText("Please check your internet connection.")
                                .setContentTitle("No internet")
                                .setSmallIcon(R.drawable.logo);
                        builder.setContentIntent(pendingIntent);
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
                            startForeground(101, builder.build());
                        }


                    }
                }) {
                    @Override
                    protected Map<String, String> getParams() throws AuthFailureError {
                        Map<String, String> params = new HashMap<>();
                        params.put("order_id", "2");
                        return params;
                    }
                };
                NetworkRequest.getInstance(getApplicationContext()).addToRequestQueue(stringRequest);
            } catch (Exception ex) {
//                android.widget.Toast.makeText(getApplicationContext(), ""+ex, Toast.LENGTH_SHORT).show();

                ex.printStackTrace();
            }

        }

        int n = 0;

        @Override
        public void run() {

            // run on another thread
            mHandler.post(new Runnable() {
                @Override
                public void run() {

                    try {
                        checkPendingOrder();
                    } catch (Exception ex) {

                        ex.printStackTrace();

                    }


                }


            });
        }
    }


//void  initBluetooth(){
//
//
//    String address = "";
//    // Get the BLuetoothDevice object
//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
//        device = mBluetoothAdapter.getRemoteDevice(address);
//    }
//    // Attempt to connect to the device
//    BLUETOOTH_PRINTER.start();
//    BLUETOOTH_PRINTER.connect(device);
//    }

    public void playBeep(String soundName) {
        MediaPlayer mediaPlayer = new MediaPlayer();
        AssetFileDescriptor afd = null;
        try {
            afd = getAssets().openFd(soundName);
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            afd.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            mediaPlayer.prepare();
        } catch (IOException e) {
            e.printStackTrace();
        }
        mediaPlayer.start();

        final Handler handler = new Handler(Looper.getMainLooper());
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mediaPlayer.stop();
            }
        }, 10000);

    }


}










