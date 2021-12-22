#ifndef CUSTOM_FOG_INCLUDE
    #define CUSTOM_FOG_INCLUDE

    #include "UnityLightingCommon.cginc"
    float3 _FogColor;

    float _FogGlobalDensity;
    float _FogFallOff;
    float _FogHeight;
    float _FogStartDis;
    float _FogInscatteringExp;
    float _FogEndDis;

    half3 ExponentialHeightFog(half3 col, half3 posWorld)
    {
        //高度雾 
        half heightFallOff = _FogFallOff * 0.01;
        half falloff = heightFallOff * ( posWorld.y -  _WorldSpaceCameraPos.y - _FogHeight); //高度越小 越小 _FogHeight越大 越小

        //距离雾
        half3 viewDir = _WorldSpaceCameraPos - posWorld;//方向
        half rayLength = length(viewDir); //长度
        half distanceFactor = max((rayLength - _FogStartDis)/ (_FogEndDis - _FogStartDis), 0);  //距离越大 越大

        //太阳光的一个变量
        half inscatterFactor = pow(saturate(dot(-normalize(viewDir), WorldSpaceLightDir(half4(posWorld,1)))), _FogInscatteringExp); //角度越小,灯光颜色越大

        //与光与视线的角度 与距离 与高度雾
        //灯光会影响雾效颜色
        inscatterFactor *= 1-saturate(exp2(falloff)); //falloff越小 灯光颜色越大
        inscatterFactor *= distanceFactor; //距离越大 灯光颜色越大
        half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFactor));

        //高度越小
        half fogDensity = _FogGlobalDensity * exp2(-falloff); //falloff越小 fog颜色越大
        // half fogFactor = (1 - exp2(-falloff))/falloff; //falloff越小 fog颜色越大
        half fog = fogFactor * fogDensity * distanceFactor;
        return lerp(col, finalFogColor, saturate(fog)); //越大 雾效越深
    }

#endif
