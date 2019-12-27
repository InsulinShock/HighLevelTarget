/*
 * model0.h
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

#ifndef RTW_HEADER_model0_h_
#define RTW_HEADER_model0_h_
#include <cmath>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "model0_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "rt_nonfinite.h"
#include "rtGetInf.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block signals (default storage) */
typedef struct {
  real_T UniformRandomNumber1;         /* '<Root>/Uniform Random Number1' */
} B_model0_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T UniformRandomNumber1_NextOutput;/* '<Root>/Uniform Random Number1' */
  real_T UniformRandomNumber1_NextOutp_c;/* '<S1>/Uniform Random Number1' */
  uint32_T RandSeed;                   /* '<Root>/Uniform Random Number1' */
  uint32_T RandSeed_l;                 /* '<S1>/Uniform Random Number1' */
} DW_model0_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T Out2;                         /* '<Root>/Out2' */
} ExtY_model0_T;

/* Parameters (default storage) */
struct P_model0_T_ {
  real_T Out1_Y0;                      /* Computed Parameter: Out1_Y0
                                        * Referenced by: '<S1>/Out1'
                                        */
  real_T UniformRandomNumber1_Minimum; /* Expression: -1
                                        * Referenced by: '<S1>/Uniform Random Number1'
                                        */
  real_T UniformRandomNumber1_Maximum; /* Expression: 1
                                        * Referenced by: '<S1>/Uniform Random Number1'
                                        */
  real_T UniformRandomNumber1_Seed;    /* Expression: 0
                                        * Referenced by: '<S1>/Uniform Random Number1'
                                        */
  real_T Gain1_Gain;                   /* Expression: 1
                                        * Referenced by: '<S1>/Gain1'
                                        */
  real_T UniformRandomNumber1_Minimum_e;/* Expression: -1
                                         * Referenced by: '<Root>/Uniform Random Number1'
                                         */
  real_T UniformRandomNumber1_Maximum_d;/* Expression: 1
                                         * Referenced by: '<Root>/Uniform Random Number1'
                                         */
  real_T UniformRandomNumber1_Seed_n;  /* Expression: 0
                                        * Referenced by: '<Root>/Uniform Random Number1'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_model0_T {
  const char_T *errorStatus;
};

/* Class declaration for model model0 */
class model0ModelClass {
  /* public data and function members */
 public:
  /* model initialize function */
  void initialize();

  /* model step function */
  void step();

  /* model terminate function */
  void terminate();

  /* Constructor */
  model0ModelClass();

  /* Destructor */
  ~model0ModelClass();

  /* Root-level structure-based outputs get method */

  /* Root outports get method */
  const ExtY_model0_T & getExternalOutputs() const
  {
    return model0_Y;
  }

  /* Real-Time Model get method */
  RT_MODEL_model0_T * getRTM();

  /* private data and function members */
 private:
  /* Tunable parameters */
  static P_model0_T model0_P;

  /* Block signals */
  B_model0_T model0_B;

  /* Block states */
  DW_model0_T model0_DW;

  /* External outputs */
  ExtY_model0_T model0_Y;

  /* Real-Time Model */
  RT_MODEL_model0_T model0_M;

  /* private member function(s) for subsystem '<Root>/Simulink Function'*/
  void model0_f_Init();
  void f();
};

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'model0'
 * '<S1>'   : 'model0/Simulink Function'
 */
#endif                                 /* RTW_HEADER_model0_h_ */
