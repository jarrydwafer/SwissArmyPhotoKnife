package com.jarrydwafer.meter;

import android.os.Bundle;
import androidx.activity.OnBackPressedCallback;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(ShellPlugin.class);
        super.onCreate(savedInstanceState);

        // The layout is fixed-size like a camera's controls. Without this the web view scales
        // text by the Android font size, which wraps the header and pushes the reading off screen.
        bridge.getWebView().getSettings().setTextZoom(100);

        // Back closes whatever the page has open (a sheet). With nothing open the app
        // steps into the background and keeps its state, instead of being destroyed.
        getOnBackPressedDispatcher()
            .addCallback(
                this,
                new OnBackPressedCallback(true) {
                    @Override
                    public void handleOnBackPressed() {
                        bridge
                            .getWebView()
                            .evaluateJavascript(
                                "!!(window.__sapkBack && window.__sapkBack())",
                                handled -> {
                                    if (!"true".equals(handled)) moveTaskToBack(true);
                                }
                            );
                    }
                }
            );
    }
}
