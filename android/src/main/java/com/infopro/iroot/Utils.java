package com.infopro.iroot;

import android.os.Build;

import com.getcapacitor.Logger;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Method;

public class Utils {

    private Utils() throws InstantiationException {
          throw new InstantiationException("This class is not for instantiation");
      }
      /**
       * In Development - an idea of ours was to check the if selinux is enforcing - this could be disabled for some rooting apps
       * Checking for selinux mode
       *
       * @return true if selinux enabled
       */
      public static boolean isSelinuxFlagInEnabled() {
          try {
              Class<?> c = Class.forName("android.os.SystemProperties");
              Method get = c.getMethod("get", String.class);
              String selinux = (String) get.invoke(c, "ro.build.selinux");
              return "1".equals(selinux);
          } catch (Exception ignored) {

          }
          return false;
      }

    /**
     * Executes a command on the system.
     *
     * @param command A Command.
     */
    public static boolean canExecuteCommand(String command) {
        Process process = null;

        try {
            process = Runtime.getRuntime().exec(command);

            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));

            return in.readLine() != null;
        } catch (Exception e) {
            Logger.error(Constants.LOG_TAG, String.format("[canExecuteCommand] Error: %s", e.getMessage()), e);

            return false;
        } finally {
            if (process != null) {
                process.destroy();
            }
        }
    }

    /**
     * Get device information.
     */
    public static void getDeviceInfo() {
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.DEVICE", Build.DEVICE));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.MODEL", Build.MODEL));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.MANUFACTURER", Build.MANUFACTURER));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.BRAND", Build.BRAND));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.HARDWARE", Build.HARDWARE));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.PRODUCT", Build.PRODUCT));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.FINGERPRINT", Build.FINGERPRINT));
        Logger.debug(Constants.LOG_TAG, String.format("[getDeviceInfo][%20s][%s]", "Build.HOST", Build.HOST));
    }
}
