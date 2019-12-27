//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: model0.h
//
// Code generated for Simulink model 'model0'.
//
// Model version                  : 1.13
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Mon Dec 23 09:03:17 2019
//
// Target selection: ert.tlc
// Embedded hardware selection: Intel->x86-64 (Windows64)
// Code generation objectives: Unspecified
// Validation result: Not run
//
#ifndef RTW_HEADER_model0_h_
#define RTW_HEADER_model0_h_
#include <stddef.h>
#include "rtwtypes.h"
#include "model0_types.h"

// Macros for accessing real-time model data structure
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

// Class declaration for model model0
class model0ModelClass {
  // public data and function members
 public:
  // External inputs (root inport signals with default storage)
  typedef struct {
    real_T In1;                        // '<Root>/In1'
  } ExtU_model0_T;

  // External outputs (root outports fed by signals with default storage)
  typedef struct {
    real_T Out2;                       // '<Root>/Out2'
  } ExtY_model0_T;

  // Real-time Model Data Structure
  struct RT_MODEL_model0_T {
    const char_T * volatile errorStatus;
  };

  // model initialize function
  void initialize();

  // model step function
  void fun();

  // model terminate function
  void terminate();

  // Constructor
  model0ModelClass();

  // Destructor
  ~model0ModelClass();

  // Root-level structure-based inputs set method

  // Root inports set method
  void setExternalInputs(const ExtU_model0_T* pExtU_model0_T)
  {
    model0_U = *pExtU_model0_T;
  }

  // Root-level structure-based outputs get method

  // Root outports get method
  const model0ModelClass::ExtY_model0_T & getExternalOutputs() const
  {
    return model0_Y;
  }

  // Real-Time Model get method
  model0ModelClass::RT_MODEL_model0_T * getRTM();

  // private data and function members
 private:
  // External inputs
  ExtU_model0_T model0_U;

  // External outputs
  ExtY_model0_T model0_Y;

  // Real-Time Model
  RT_MODEL_model0_T model0_M;
};

//-
//  The generated code includes comments that allow you to trace directly
//  back to the appropriate location in the model.  The basic format
//  is <system>/block_name, where system is the system number (uniquely
//  assigned by Simulink) and block_name is the name of the block.
//
//  Use the MATLAB hilite_system command to trace the generated code back
//  to the model.  For example,
//
//  hilite_system('<S3>')    - opens system 3
//  hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
//
//  Here is the system hierarchy for this model
//
//  '<Root>' : 'model0'
//  '<S1>'   : 'model0/Function-Call Subsystem'

#endif                                 // RTW_HEADER_model0_h_

//
// File trailer for generated code.
//
// [EOF]
//
