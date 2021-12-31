package uk.co.ordervox.merchant

import android.Manifest
import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import uk.co.ordervox.myapplication.DownloadController


class MainActivity: FlutterActivity() {

    companion object {
        const val PERMISSION_REQUEST_STORAGE = 0
    }

    lateinit var downloadController: DownloadController

    private val BATTERY_CHANNEL = "samples.flutter.io/battery"

    var forService: Intent? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        forService =  Intent(this, MyService::class.java)

//
//        val apkUrl = "https://github.com/faithonline002/app/raw/main/ordere_mechant.apk"
//        downloadController = DownloadController(this, apkUrl)



    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        if (requestCode == PERMISSION_REQUEST_STORAGE) {
            // Request for camera permission.
            if (grantResults.size == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // start downloading
                downloadController.enqueueDownload()
            } else {
                // Permission request was denied.
                //findViewById<ConstraintLayout>(R.id.mainLayout).showSnackbar("R.string.storage_permission_denied", Snackbar.LENGTH_SHORT)
            }
        }
    }


    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkStoragePermission() {

        Log.e("autoupdate___","checkStoragePermission")
        // Check if the storage permission has been granted
        if (ContextCompat.checkSelfPermission(this,Manifest.permission.WRITE_EXTERNAL_STORAGE) ==
                PackageManager.PERMISSION_GRANTED
        ) {
            // start downloading
            Log.e("autoupdate___","enqueueDownload")
            downloadController.enqueueDownload()
        } else {
            Log.e("autoupdate___","requestStoragePermission")
            // Permission is missing and must be requested.
            requestStoragePermission()
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun requestStoragePermission() {

        if (shouldShowRequestPermissionRationale(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

                requestPermissions(
                        arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                        PERMISSION_REQUEST_STORAGE
                )


        } else {
            Log.e("autoupdate___","requestStoragePermission  else")
            requestPermissions(
                    arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                    PERMISSION_REQUEST_STORAGE
            )
        }
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor, BATTERY_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPendingOrders") {

                val domain = call.argument<String>("domain")
                MyService.url = domain

                if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
                    startForegroundService(forService)
                }else{
                    startService(forService)
                }


            } else if(call.method == "update_app"){

                // check storage permission granted if yes then start downloading file
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    checkStoragePermission()
                }

            }
            else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopService(forService)
    }

    @SuppressLint("ServiceCast")
    override fun onPause() {

        val activityManager = applicationContext
                .getSystemService(ACTIVITY_SERVICE) as ActivityManager
//
////        Log.e("locker____", "isMerchant : $isMerchant")
//
//        Log.e("locker____", "inside if")
        activityManager.moveTaskToFront(taskId, 0)
        
        super.onPause()
    }




}