package com.infopro.iroot;

import android.content.Context;

public class IRoot {

    private InternalRootDetection internalRootDetection = new InternalRootDetection();

    public boolean isRooted(Context context) {
        return internalRootDetection.isRooted(context);
    }
}
