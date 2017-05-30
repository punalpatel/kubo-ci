// Code generated by counterfeiter. DO NOT EDIT.
package vspherefakes

import (
	"sync"
	"vsphere-cleaner/vsphere"
)

type FakeClient struct {
	DeleteVMStub        func(string) error
	deleteVMMutex       sync.RWMutex
	deleteVMArgsForCall []struct {
		arg1 string
	}
	deleteVMReturns struct {
		result1 error
	}
	deleteVMReturnsOnCall map[int]struct {
		result1 error
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *FakeClient) DeleteVM(arg1 string) error {
	fake.deleteVMMutex.Lock()
	ret, specificReturn := fake.deleteVMReturnsOnCall[len(fake.deleteVMArgsForCall)]
	fake.deleteVMArgsForCall = append(fake.deleteVMArgsForCall, struct {
		arg1 string
	}{arg1})
	fake.recordInvocation("DeleteVM", []interface{}{arg1})
	fake.deleteVMMutex.Unlock()
	if fake.DeleteVMStub != nil {
		return fake.DeleteVMStub(arg1)
	}
	if specificReturn {
		return ret.result1
	}
	return fake.deleteVMReturns.result1
}

func (fake *FakeClient) DeleteVMCallCount() int {
	fake.deleteVMMutex.RLock()
	defer fake.deleteVMMutex.RUnlock()
	return len(fake.deleteVMArgsForCall)
}

func (fake *FakeClient) DeleteVMArgsForCall(i int) string {
	fake.deleteVMMutex.RLock()
	defer fake.deleteVMMutex.RUnlock()
	return fake.deleteVMArgsForCall[i].arg1
}

func (fake *FakeClient) DeleteVMReturns(result1 error) {
	fake.DeleteVMStub = nil
	fake.deleteVMReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeClient) DeleteVMReturnsOnCall(i int, result1 error) {
	fake.DeleteVMStub = nil
	if fake.deleteVMReturnsOnCall == nil {
		fake.deleteVMReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.deleteVMReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *FakeClient) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.deleteVMMutex.RLock()
	defer fake.deleteVMMutex.RUnlock()
	copiedInvocations := map[string][][]interface{}{}
	for key, value := range fake.invocations {
		copiedInvocations[key] = value
	}
	return copiedInvocations
}

func (fake *FakeClient) recordInvocation(key string, args []interface{}) {
	fake.invocationsMutex.Lock()
	defer fake.invocationsMutex.Unlock()
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
	fake.invocations[key] = append(fake.invocations[key], args)
}

var _ vsphere.Client = new(FakeClient)
