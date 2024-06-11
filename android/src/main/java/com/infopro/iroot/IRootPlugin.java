package com.infopro.iroot;

import android.content.Context;

import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import com.scottyab.rootbeer.RootBeer;

@CapacitorPlugin(name = "IRoot")
public class IRootPlugin extends Plugin {

    private IRoot implementation = new IRoot();

    @PluginMethod
    public void isRooted(PluginCall call) {

        Context context = this.getContext();

        RootBeer rootBeer = new RootBeer(context);
        boolean checkRootBeer = rootBeer.isRooted();

        boolean checkInternal = implementation.isRooted(context);

        Logger.debug(Constants.LOG_TAG, "[isRooted] checkRootBeer: " + checkRootBeer);
        Logger.debug(Constants.LOG_TAG, "[isRooted] checkInternal: " + checkInternal);

        boolean isRooted = checkRootBeer || checkInternal;

        JSObject ret = new JSObject();
        ret.put("value", isRooted);
        call.resolve(ret);
    }
}
