#global describe, it
'use strict'

define ['GA'], (GA) ->

    assert = chai.assert
    sinon.assert.expose assert,
        prefix: ''

    beforeEach ->
        GA.ga = sinon.spy()
        if GA.config.fields
            GA.config.fields = {}
        GA.ecomLoaded = false
        return


    describe 'RequireJS Google Analytics', ->

        describe 'constructor', ->
            it 'should create a tracker and track a pageview', ->
                gaSpy2 = sinon.spy()
                GA2 = GA.newTracker
                    id: 'UA-SECOND-TRACKER'
                    ga: gaSpy2
                assert.calledTwice gaSpy2
                assert.equal true, gaSpy2.getCall(0).calledWith('create', 'UA-SECOND-TRACKER')
                assert.equal true, gaSpy2.getCall(1).calledWith('send', 'pageview')

            it 'should support create only fields', ->
                fields =
                    clientId: '35009a79-1a05-49d7-b876-2b884d0f825b'
                    sampleRate: 100
                gaSpy2 = sinon.spy()
                GA2 = GA.newTracker
                    id: 'UA-SECOND-TRACKER'
                    fields: fields
                    ga: gaSpy2
                assert.calledTwice gaSpy2
                assert.equal true, gaSpy2.getCall(0).calledWith('create', 'UA-SECOND-TRACKER', fields)
                assert.equal true, gaSpy2.getCall(1).calledWith('send', 'pageview')

            it 'should support experiments', ->
                gaSpy2 = sinon.spy()
                GA2 = GA.newTracker
                    id: 'UA-SECOND-TRACKER'
                    ga: gaSpy2
                    expId: 'foo'
                    expVar: 'bar'
                assert.callCount gaSpy2, 4
                assert.equal true, gaSpy2.getCall(0).calledWith('create', 'UA-SECOND-TRACKER')
                assert.equal true, gaSpy2.getCall(1).calledWith('set', 'expId', 'foo')
                assert.equal true, gaSpy2.getCall(2).calledWith('set', 'expVar', 'bar')
                assert.equal true, gaSpy2.getCall(3).calledWith('send', 'pageview')

            it 'should allow the automatic pageview to be disabled', ->
                gaSpy2 = sinon.spy()
                GA2 = GA.newTracker
                    id: 'UA-SECOND-TRACKER'
                    ga: gaSpy2
                    noAutoView: true
                assert.calledOnce gaSpy2
                assert.equal true, gaSpy2.getCall(0).calledWith('create', 'UA-SECOND-TRACKER')


        describe 'newTracker', ->
            it 'should return a new tracker', ->
                # TODO: Come up with a test for this


        describe 'ready', ->
            it 'should run callbacks when ready', (done) ->
                GA2 = GA.newTracker
                    id: 'UA-SECOND-TRACKER'
                    ga: sinon.stub()
                GA2.ready ->
                    done()

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ready ->
                    return


        describe '__ga', ->
            it 'should pass arguments directly to ga', ->
                GA.__ga('foo', 'bar')
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'foo', 'bar'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.__ga('foo', 'bar')
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.foo', 'bar'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.__ga('foo', 'bar')


        describe 'create', ->
            it 'should send the create command', ->
                GA.create('id')
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'create', 'id'

            it 'should use auto', ->
                GA.create('id', 'auto')
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'create', 'id', 'auto'

            it 'should use create only fields', ->
                GA.create 'id',
                    name: 'secondTracker'
                    clientId: '35009a79-1a05-49d7-b876-2b884d0f825b'
                    sampleRate: 100
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'create', 'id',
                    name: 'secondTracker'
                    clientId: '35009a79-1a05-49d7-b876-2b884d0f825b'
                    sampleRate: 100

            it 'should use auto and create only fields', ->
                GA.create 'id', 'auto',
                    name: 'secondTracker'
                    clientId: '35009a79-1a05-49d7-b876-2b884d0f825b'
                    sampleRate: 100
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'create', 'id', 'auto',
                    name: 'secondTracker'
                    clientId: '35009a79-1a05-49d7-b876-2b884d0f825b'
                    sampleRate: 100

            it 'should not prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.create('id')
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'create', 'id'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.create 'id'


        describe 'set', ->
            it 'should set a key to a value', ->
                GA.set 'key', 'value'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'set', 'key', 'value'

            it 'should set multiple keys and values', ->
                GA.set
                    foo: 'bar'
                    bar: 'foo'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'set',
                    foo: 'bar'
                    bar: 'foo'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.set 'key', 'value'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.set', 'key', 'value'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.set 'key', 'value'


        describe 'send', ->
            it 'should pass arguments directly', ->
                GA.send 'foo', 'bar'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'foo', 'bar'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.send()
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.send'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.send()


        describe 'require', ->
            it 'should pass arguments directly', ->
                GA.require 'foo', 'bar'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'require', 'foo', 'bar'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.require()
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.require'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.send()


        describe 'view', ->
            it 'should override the default page value', ->
                GA.view '/my-overridden-page?id=1'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'pageview', '/my-overridden-page?id=1'

            it 'should override multiple values', ->
                GA.view
                    page: '/my-overridden-page?id=1'
                    title: 'my overridden page'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'pageview',
                    page: '/my-overridden-page?id=1'
                    title: 'my overridden page'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.view()
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.send', 'pageview'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.view()


        describe 'event', ->
            it 'should send an event', ->
                GA.event 'category', 'action'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'event', 'category', 'action'

            it 'should accept labels', ->
                GA.event 'category', 'action', 'label'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'event', 'category', 'action', 'label'

            it 'should accept values', ->
                GA.event 'category', 'action', 'label', 4
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'event', 'category', 'action', 'label', 4

            it 'should accept optional field names and values', ->
                GA.event 'category', 'action', 'label', 4,
                    page: '/my-new-page'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'event', 'category', 'action', 'label', 4,
                    page: '/my-new-page'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.event 'category', 'action'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.send', 'event', 'category', 'action'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.event 'category', 'action'


        describe 'social', ->
            it 'should send a social interaction', ->
                GA.social 'network', 'action', 'target'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'social', 'network', 'action', 'target'

            it 'should accept optional field names and values', ->
                GA.social 'network', 'action', 'target',
                    page: '/my-new-page'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'social', 'network', 'action', 'target',
                    page: '/my-new-page'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.social 'network', 'action', 'target'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.send', 'social', 'network', 'action', 'target'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.social 'network', 'action', 'target'


        describe 'timing', ->
            it 'should send a user timing', ->
                GA.timing 'category', 'var', 4
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'timing', 'category', 'var', 4

            it 'should accept labels', ->
                GA.timing 'category', 'var', 4, 'label'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'timing', 'category', 'var', 4, 'label'

            it 'should accept optional field names and values', ->
                GA.timing 'category', 'var', 4, 'label',
                    page: '/my-new-page'
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'send', 'timing', 'category', 'var', 4, 'label',
                    page: '/my-new-page'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.timing 'category', 'var', 4
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'secondTracker.send', 'timing', 'category', 'var', 4

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.timing 'category', 'var', 4


        describe 'ecomLoad', ->
            it 'should require ecommerce.js', ->
                GA.ecomLoad()
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'require', 'ecommerce', 'ecommerce.js'

            it 'should only require ecommerce.js once', ->
                GA.ecomLoad()
                GA.ecomLoad()
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'require', 'ecommerce', 'ecommerce.js'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.ecomLoad()
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'secondTracker.require', 'ecommerce', 'ecommerce.js'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ecomLoad()


        describe 'ecomTran', ->
            it 'should automatically call ecomLoad', ->
                ecomLoadSpy = sinon.spy(GA, 'ecomLoad')
                GA.ecomTran
                    id: '1234'
                assert.calledOnce ecomLoadSpy
                ecomLoadSpy.restore()

            it 'should pass fields in directly', ->
                fields =
                    id: '1234'
                GA.ecomLoaded = true
                GA.ecomTran fields
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'ecommerce:addTransaction', fields
                assert.strictEqual GA.ga.firstCall.args[1], fields

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.ecomLoaded = true
                GA.ecomTran
                    id: '1234'
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'secondTracker.ecommerce:addTransaction',
                    id: '1234'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ecomTran
                    id: '1234'


        describe 'ecomItem', ->
            it 'should automatically call ecomLoad', ->
                ecomLoadSpy = sinon.spy(GA, 'ecomLoad')
                GA.ecomItem
                    id: '1234'
                    name: 'Foo'
                assert.calledOnce ecomLoadSpy
                ecomLoadSpy.restore()

            it 'should pass fields in directly', ->
                fields =
                    id: '1234'
                GA.ecomLoaded = true
                GA.ecomItem fields
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'ecommerce:addItem', fields
                assert.strictEqual GA.ga.firstCall.args[1], fields

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.ecomLoaded = true
                GA.ecomItem
                    id: '1234'
                    name: 'Foo'
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'secondTracker.ecommerce:addItem',
                    id: '1234'
                    name: 'Foo'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ecomItem
                    id: '1234'
                    name: 'Foo'


        describe 'ecomSend', ->
            it 'should automatically call ecomLoad', ->
                ecomLoadSpy = sinon.spy(GA, 'ecomLoad')
                GA.ecomSend()
                assert.calledOnce ecomLoadSpy
                ecomLoadSpy.restore()

            it 'should issue send command', ->
                GA.ecomLoaded = true
                GA.ecomSend()
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'ecommerce:send'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.ecomLoaded = true
                GA.ecomSend()
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'secondTracker.ecommerce:send'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ecomSend()


        describe 'ecomClear', ->
            it 'should automatically call ecomLoad', ->
                ecomLoadSpy = sinon.spy(GA, 'ecomLoad')
                GA.ecomClear()
                assert.calledOnce ecomLoadSpy
                ecomLoadSpy.restore()

            it 'should issue clear command', ->
                GA.ecomLoaded = true
                GA.ecomClear()
                assert.callCount GA.ga, 1
                assert.calledWith GA.ga, 'ecommerce:clear'

            it 'should prefix the command with the trackers name', ->
                GA.config.fields = {'name': 'secondTracker'}
                GA.ecomLoaded = true
                GA.ecomClear()
                assert.calledOnce GA.ga
                assert.calledWith GA.ga, 'secondTracker.ecommerce:clear'

            it 'should return the tracker for chaining', ->
                assert.strictEqual GA, GA.ecomClear()
