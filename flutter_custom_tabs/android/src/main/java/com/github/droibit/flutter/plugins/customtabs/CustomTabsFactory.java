package com.github.droibit.flutter.plugins.customtabs;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.AnimRes;
import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.browser.customtabs.CustomTabsIntent;

import com.droibit.android.customtabs.launcher.CustomTabsFallback;
import com.droibit.android.customtabs.launcher.CustomTabsLauncher;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@SuppressWarnings({"ConstantConditions", "unchecked"})
@RestrictTo(RestrictTo.Scope.LIBRARY)
class CustomTabsFactory {
    private static final String KEY_OPTIONS_TOOLBAR_COLOR = "toolbarColor";
    private static final String KEY_OPTIONS_URL_BAR_HIDING_ENABLED = "urlBarHidingEnabled";
    private static final String KEY_OPTIONS_SHOW_PAGE_TITLE = "showPageTitle";
    private static final String KEY_OPTIONS_SHARE_STATE = "shareState";
    private static final String KEY_OPTIONS_ENABLE_INSTANT_APPS = "enableInstantApps";
    private static final String KEY_OPTIONS_ANIMATIONS = "animations";
    private static final String KEY_CLOSE_BUTTON_POSITION = "closeButtonPosition";
    private static final String KEY_HEADERS = "headers";
    private static final String KEY_ANIMATION_START_ENTER = "startEnter";
    private static final String KEY_ANIMATION_START_EXIT = "startExit";
    private static final String KEY_ANIMATION_END_ENTER = "endEnter";
    private static final String KEY_ANIMATION_END_EXIT = "endExit";
    private static final String KEY_EXTRA_CUSTOM_TABS = "extraCustomTabs";

    // Note: The full resource qualifier is "package:type/entry".
    // https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String, java.lang.String, java.lang.String)
    private static final Pattern animationIdentifierPattern = Pattern.compile("^.+:.+/");

    private final Context context;

    CustomTabsFactory(@NonNull Context context) {
        this.context = context;
    }

    @NonNull
    CustomTabsIntent createIntent(@NonNull Map<String, Object> options) {
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        if (options.containsKey(KEY_OPTIONS_TOOLBAR_COLOR)) {
            final String colorString = (String) options.get(KEY_OPTIONS_TOOLBAR_COLOR);
            builder.setToolbarColor(Color.parseColor(colorString));
        }

        if (options.containsKey(KEY_OPTIONS_URL_BAR_HIDING_ENABLED)) {
            builder.setUrlBarHidingEnabled(((Boolean) options.get(KEY_OPTIONS_URL_BAR_HIDING_ENABLED)));
        }

        if (options.containsKey(KEY_OPTIONS_SHARE_STATE)) {
             final int shareState = ((int) options.get(KEY_OPTIONS_SHARE_STATE));
             builder.setShareState(shareState);
        }

        if (options.containsKey(KEY_OPTIONS_SHOW_PAGE_TITLE)) {
            builder.setShowTitle(((Boolean) options.get(KEY_OPTIONS_SHOW_PAGE_TITLE)));
        }

        if (options.containsKey(KEY_OPTIONS_ENABLE_INSTANT_APPS)) {
            builder.setInstantAppsEnabled(((Boolean) options.get(KEY_OPTIONS_ENABLE_INSTANT_APPS)));
        }

        if (options.containsKey(KEY_OPTIONS_ANIMATIONS)) {
            applyAnimations(builder, ((Map<String, String>) options.get(KEY_OPTIONS_ANIMATIONS)));
        }

        if (options.containsKey(KEY_CLOSE_BUTTON_POSITION)) {
            final int position = (int) options.get(KEY_CLOSE_BUTTON_POSITION);
            builder.setCloseButtonPosition(position);
        }

        final CustomTabsIntent customTabsIntent = builder.build();
        onPostBuild(customTabsIntent.intent, options);
        return customTabsIntent;
    }

    private void onPostBuild(@NonNull Intent intent, @NonNull Map<String, Object> options) {
        if (options.containsKey(KEY_HEADERS)) {
            Map<String, String> headers = (Map<String, String>) options.get(KEY_HEADERS);
            Bundle bundleHeaders = new Bundle();
            for (Map.Entry<String, String> header : headers.entrySet()) {
                bundleHeaders.putString(header.getKey(), header.getValue());
            }
            intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }
    }

    private void applyAnimations(@NonNull CustomTabsIntent.Builder builder,
                                 @NonNull Map<String, String> animations) {
        final int startEnterAnimationId =
                animations.containsKey(KEY_ANIMATION_START_ENTER) ? resolveAnimationIdentifierIfNeeded(
                        animations.get(KEY_ANIMATION_START_ENTER)) : 0;
        final int startExitAnimationId =
                animations.containsKey(KEY_ANIMATION_START_EXIT) ? resolveAnimationIdentifierIfNeeded(
                        animations.get(KEY_ANIMATION_START_EXIT)) : 0;
        final int endEnterAnimationId =
                animations.containsKey(KEY_ANIMATION_END_ENTER) ? resolveAnimationIdentifierIfNeeded(
                        animations.get(KEY_ANIMATION_END_ENTER)) : 0;
        final int endExitAnimationId =
                animations.containsKey(KEY_ANIMATION_END_EXIT) ? resolveAnimationIdentifierIfNeeded(
                        animations.get(KEY_ANIMATION_END_EXIT)) : 0;

        if (startEnterAnimationId != 0 && startExitAnimationId != 0) {
            builder.setStartAnimations(context, startEnterAnimationId, startExitAnimationId);
        }

        if (endEnterAnimationId != 0 && endExitAnimationId != 0) {
            builder.setExitAnimations(context, endEnterAnimationId, endExitAnimationId);
        }
    }

    @SuppressLint("DiscouragedApi")
    @AnimRes
    private int resolveAnimationIdentifierIfNeeded(@NonNull String identifier) {
        if (animationIdentifierPattern.matcher(identifier).find()) {
            return context.getResources().getIdentifier(identifier, null, null);
        } else {
            return context.getResources().getIdentifier(identifier, "anim", context.getPackageName());
        }
    }

    @NonNull
    CustomTabsFallback createFallback(@NonNull Map<String, Object> options) {
        final List<String> extraCustomTabs;
        if (options.containsKey(KEY_EXTRA_CUSTOM_TABS)) {
            extraCustomTabs = ((List<String>) options.get(KEY_EXTRA_CUSTOM_TABS));
        } else {
            extraCustomTabs = null;
        }

        final CustomTabsFallback fallback;
        if (extraCustomTabs != null && !extraCustomTabs.isEmpty()) {
            fallback = new CustomTabsLauncher.LaunchNonChromeCustomTabs(extraCustomTabs);
        } else {
            fallback = new CustomTabsLauncher.LaunchNonChromeCustomTabs(context);
        }
        return fallback;
    }
}
