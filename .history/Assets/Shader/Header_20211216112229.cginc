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
        half falloff = heightFallOff * ( posWorld.y -  _WorldSpaceCameraPos.y - _FogHeight); //高度越小 越小

        //距离雾与光焰光有关
        half3 viewDir = _WorldSpaceCameraPos - posWorld;//方向
        half rayLength = length(viewDir); //长度
        half distanceFactor = max((rayLength - _FogStartDis)/ (_FogEndDis - _FogStartDis), 0);  //奇怪

        //太阳光的一个变量
        half inscatterFactor = pow(saturate(dot(-normalize(viewDir), WorldSpaceLightDir(half4(posWorld,1)))), _FogInscatteringExp); //太阳光的方向
        inscatterFactor *= 1-saturate(exp2(falloff));
        inscatterFactor *= distanceFactor;

        //光与雾的差值
        half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFactor));

        half fogDensity = _FogGlobalDensity * exp2(-falloff);
        half fogFactor = (1 - exp2(-falloff))/falloff;
        half fog = fogFactor * fogDensity * distanceFactor;//插值


        return lerp(col, finalFogColor, saturate(fog));
    }

#endif
