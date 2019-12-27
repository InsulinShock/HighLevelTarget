/*
 * model0.cpp
 *
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 *
 * Code generation for model "model0".
 *
 * Model version              : 1.9
 * Simulink Coder version : 9.3 (R2020a) 18-Nov-2019
 * C++ source code generated on : Sun Dec 22 22:29:58 2019
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "model0.h"
#include "model0_private.h"
#include "rt_urand_Upu32_Yd_f_pw_snf.h"

/* System initialize for Simulink Function: '<Root>/Simulink Function' */
void model0ModelClass::model0_f_Init()
{
  uint32_T tseed;
  int32_T r;
  int32_T t;
  real_T tmp;

  /* InitializeConditions for UniformRandomNumber: '<S1>/Uniform Random Number1' */
  tmp = std::floor(model0_P.UniformRandomNumber1_Seed);
  if (rtIsNaN(tmp) || rtIsInf(tmp)) {
    tmp = 0.0;
  } else {
    tmp = std::fmod(tmp, 4.294967296E+9);
  }

  tseed = tmp < 0.0 ? static_cast<uint32_T>(-static_cast<int32_T>
    (static_cast<uint32_T>(-tmp))) : static_cast<uint32_T>(tmp);
  r = static_cast<int32_T>((tseed >> 16U));
  t = static_cast<int32_T>((tseed & 32768U));
  tseed = ((((tseed - (static_cast<uint32_T>(r) << 16U)) + t) << 16U) + t) + r;
  if (tseed < 1U) {
    tseed = 1144108930U;
  } else {
    if (tseed > 2147483646U) {
      tseed = 2147483646U;
    }
  }

  model0_DW.RandSeed_l = tseed;
  model0_DW.UniformRandomNumber1_NextOutp_c =
    (model0_P.UniformRandomNumber1_Maximum -
     model0_P.UniformRandomNumber1_Minimum) * rt_urand_Upu32_Yd_f_pw_snf
    (&model0_DW.RandSeed_l) + model0_P.UniformRandomNumber1_Minimum;

  /* End of InitializeConditions for UniformRandomNumber: '<S1>/Uniform Random Number1' */

  /* SystemInitialize for Outport: '<Root>/Out2' incorporates:
   *  Outport: '<S1>/Out1'
   */
  model0_Y.Out2 = model0_P.Out1_Y0;
}

/* Output and update for Simulink Function: '<Root>/Simulink Function' */
void model0ModelClass::f()
{
}

/* Model step function */
void model0ModelClass::step()
{
  /* UniformRandomNumber: '<Root>/Uniform Random Number1' */
  model0_B.UniformRandomNumber1 = model0_DW.UniformRandomNumber1_NextOutput;

  /* Update for UniformRandomNumber: '<Root>/Uniform Random Number1' */
  model0_DW.UniformRandomNumber1_NextOutput =
    (model0_P.UniformRandomNumber1_Maximum_d -
     model0_P.UniformRandomNumber1_Minimum_e) * rt_urand_Upu32_Yd_f_pw_snf
    (&model0_DW.RandSeed) + model0_P.UniformRandomNumber1_Minimum_e;
}

/* Model initialize function */
void model0ModelClass::initialize()
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  {
    uint32_T tseed;
    int32_T r;
    int32_T t;
    real_T tmp;

    /* InitializeConditions for UniformRandomNumber: '<Root>/Uniform Random Number1' */
    tmp = std::floor(model0_P.UniformRandomNumber1_Seed_n);
    if (rtIsNaN(tmp) || rtIsInf(tmp)) {
      tmp = 0.0;
    } else {
      tmp = std::fmod(tmp, 4.294967296E+9);
    }

    tseed = tmp < 0.0 ? static_cast<uint32_T>(-static_cast<int32_T>
      (static_cast<uint32_T>(-tmp))) : static_cast<uint32_T>(tmp);
    r = static_cast<int32_T>((tseed >> 16U));
    t = static_cast<int32_T>((tseed & 32768U));
    tseed = ((((tseed - (static_cast<uint32_T>(r) << 16U)) + t) << 16U) + t) + r;
    if (tseed < 1U) {
      tseed = 1144108930U;
    } else {
      if (tseed > 2147483646U) {
        tseed = 2147483646U;
      }
    }

    model0_DW.RandSeed = tseed;
    model0_DW.UniformRandomNumber1_NextOutput =
      (model0_P.UniformRandomNumber1_Maximum_d -
       model0_P.UniformRandomNumber1_Minimum_e) * rt_urand_Upu32_Yd_f_pw_snf
      (&model0_DW.RandSeed) + model0_P.UniformRandomNumber1_Minimum_e;

    /* End of InitializeConditions for UniformRandomNumber: '<Root>/Uniform Random Number1' */

    /* SystemInitialize for S-Function (sfun_private_function_caller) generated from: '<Root>/Simulink Function' incorporates:
     *  SubSystem: '<Root>/Simulink Function'
     */
    model0_f_Init();

    /* End of SystemInitialize for S-Function (sfun_private_function_caller) generated from: '<Root>/Simulink Function' */
  }
}

/* Model terminate function */
void model0ModelClass::terminate()
{
  /* (no terminate code required) */
}

/* Constructor */
model0ModelClass::model0ModelClass():
  model0_B()
  ,model0_DW()
  ,model0_Y()
  ,model0_M()
{
  /* Currently there is no constructor body generated.*/
}

/* Destructor */
model0ModelClass::~model0ModelClass()
{
  /* Currently there is no destructor body generated.*/
}

/* Real-Time Model get method */
RT_MODEL_model0_T * model0ModelClass::getRTM()
{
  return (&model0_M);
}
