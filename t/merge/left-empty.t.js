require('./proof')(3, prove)

function prove (async, assert) {
    var strata = createStrata({ directory: tmp, leafSize: 3, branchSize: 3 })
    async(function () {
        serialize(__dirname + '/fixtures/merge.before.json', tmp, async())
    }, function () {
        strata.open(async())
    }, function () {
        strata.mutator('a', async())
    }, function (cursor) {
        cursor.remove(cursor.indexOf('a', cursor.page.ghosts))
        cursor.remove(cursor.indexOf('b', cursor.page.ghosts))
        cursor.unlock(async())
    }, function () {
        gather(strata, async())
    }, function (records) {
        assert(records, [ 'c', 'd' ], 'records')
        strata.balance(async())
    }, function () {
        vivify(tmp, async())
        load(__dirname + '/fixtures/left-empty.after.json', async())
    }, function (actual, expected) {
        assert.say(expected)
        assert.say(actual)

        assert(actual, expected, 'merge')
    }, function () {
        gather(strata, async())
    }, function (records) {
        assert(records, [ 'c', 'd' ], 'merged')
    }, function() {
        strata.close(async())
    })
}
