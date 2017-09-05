// This file was generated by counterfeiter
package fakes

import (
	"sync"
	"time"

	"github.com/pivotal-golang/clock"
)

type FakeClock struct {
	NowStub        func() time.Time
	nowMutex       sync.RWMutex
	nowArgsForCall []struct{}
	nowReturns     struct {
		result1 time.Time
	}
	SleepStub        func(d time.Duration)
	sleepMutex       sync.RWMutex
	sleepArgsForCall []struct {
		d time.Duration
	}
	SinceStub        func(t time.Time) time.Duration
	sinceMutex       sync.RWMutex
	sinceArgsForCall []struct {
		t time.Time
	}
	sinceReturns struct {
		result1 time.Duration
	}
	NewTimerStub        func(d time.Duration) clock.Timer
	newTimerMutex       sync.RWMutex
	newTimerArgsForCall []struct {
		d time.Duration
	}
	newTimerReturns struct {
		result1 clock.Timer
	}
	NewTickerStub        func(d time.Duration) clock.Ticker
	newTickerMutex       sync.RWMutex
	newTickerArgsForCall []struct {
		d time.Duration
	}
	newTickerReturns struct {
		result1 clock.Ticker
	}
	invocations map[string][][]interface{}
}

func (fake *FakeClock) Now() time.Time {
	fake.nowMutex.Lock()
	fake.nowArgsForCall = append(fake.nowArgsForCall, struct{}{})
	fake.guard("Now")
	fake.invocations["Now"] = append(fake.invocations["Now"], []interface{}{})
	fake.nowMutex.Unlock()
	if fake.NowStub != nil {
		return fake.NowStub()
	} else {
		return fake.nowReturns.result1
	}
}

func (fake *FakeClock) NowCallCount() int {
	fake.nowMutex.RLock()
	defer fake.nowMutex.RUnlock()
	return len(fake.nowArgsForCall)
}

func (fake *FakeClock) NowReturns(result1 time.Time) {
	fake.NowStub = nil
	fake.nowReturns = struct {
		result1 time.Time
	}{result1}
}

func (fake *FakeClock) Sleep(d time.Duration) {
	fake.sleepMutex.Lock()
	fake.sleepArgsForCall = append(fake.sleepArgsForCall, struct {
		d time.Duration
	}{d})
	fake.guard("Sleep")
	fake.invocations["Sleep"] = append(fake.invocations["Sleep"], []interface{}{d})
	fake.sleepMutex.Unlock()
	if fake.SleepStub != nil {
		fake.SleepStub(d)
	}
}

func (fake *FakeClock) SleepCallCount() int {
	fake.sleepMutex.RLock()
	defer fake.sleepMutex.RUnlock()
	return len(fake.sleepArgsForCall)
}

func (fake *FakeClock) SleepArgsForCall(i int) time.Duration {
	fake.sleepMutex.RLock()
	defer fake.sleepMutex.RUnlock()
	return fake.sleepArgsForCall[i].d
}

func (fake *FakeClock) Since(t time.Time) time.Duration {
	fake.sinceMutex.Lock()
	fake.sinceArgsForCall = append(fake.sinceArgsForCall, struct {
		t time.Time
	}{t})
	fake.guard("Since")
	fake.invocations["Since"] = append(fake.invocations["Since"], []interface{}{t})
	fake.sinceMutex.Unlock()
	if fake.SinceStub != nil {
		return fake.SinceStub(t)
	} else {
		return fake.sinceReturns.result1
	}
}

func (fake *FakeClock) SinceCallCount() int {
	fake.sinceMutex.RLock()
	defer fake.sinceMutex.RUnlock()
	return len(fake.sinceArgsForCall)
}

func (fake *FakeClock) SinceArgsForCall(i int) time.Time {
	fake.sinceMutex.RLock()
	defer fake.sinceMutex.RUnlock()
	return fake.sinceArgsForCall[i].t
}

func (fake *FakeClock) SinceReturns(result1 time.Duration) {
	fake.SinceStub = nil
	fake.sinceReturns = struct {
		result1 time.Duration
	}{result1}
}

func (fake *FakeClock) NewTimer(d time.Duration) clock.Timer {
	fake.newTimerMutex.Lock()
	fake.newTimerArgsForCall = append(fake.newTimerArgsForCall, struct {
		d time.Duration
	}{d})
	fake.guard("NewTimer")
	fake.invocations["NewTimer"] = append(fake.invocations["NewTimer"], []interface{}{d})
	fake.newTimerMutex.Unlock()
	if fake.NewTimerStub != nil {
		return fake.NewTimerStub(d)
	} else {
		return fake.newTimerReturns.result1
	}
}

func (fake *FakeClock) NewTimerCallCount() int {
	fake.newTimerMutex.RLock()
	defer fake.newTimerMutex.RUnlock()
	return len(fake.newTimerArgsForCall)
}

func (fake *FakeClock) NewTimerArgsForCall(i int) time.Duration {
	fake.newTimerMutex.RLock()
	defer fake.newTimerMutex.RUnlock()
	return fake.newTimerArgsForCall[i].d
}

func (fake *FakeClock) NewTimerReturns(result1 clock.Timer) {
	fake.NewTimerStub = nil
	fake.newTimerReturns = struct {
		result1 clock.Timer
	}{result1}
}

func (fake *FakeClock) NewTicker(d time.Duration) clock.Ticker {
	fake.newTickerMutex.Lock()
	fake.newTickerArgsForCall = append(fake.newTickerArgsForCall, struct {
		d time.Duration
	}{d})
	fake.guard("NewTicker")
	fake.invocations["NewTicker"] = append(fake.invocations["NewTicker"], []interface{}{d})
	fake.newTickerMutex.Unlock()
	if fake.NewTickerStub != nil {
		return fake.NewTickerStub(d)
	} else {
		return fake.newTickerReturns.result1
	}
}

func (fake *FakeClock) NewTickerCallCount() int {
	fake.newTickerMutex.RLock()
	defer fake.newTickerMutex.RUnlock()
	return len(fake.newTickerArgsForCall)
}

func (fake *FakeClock) NewTickerArgsForCall(i int) time.Duration {
	fake.newTickerMutex.RLock()
	defer fake.newTickerMutex.RUnlock()
	return fake.newTickerArgsForCall[i].d
}

func (fake *FakeClock) NewTickerReturns(result1 clock.Ticker) {
	fake.NewTickerStub = nil
	fake.newTickerReturns = struct {
		result1 clock.Ticker
	}{result1}
}

func (fake *FakeClock) Invocations() map[string][][]interface{} {
	return fake.invocations
}

func (fake *FakeClock) guard(key string) {
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
}

var _ clock.Clock = new(FakeClock)