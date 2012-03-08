#!/usr/bin/env _coffee
require("./harness") 3, ({ Strata, directory, fixture: { load, objectify, serialize } }, _) ->
  serialize "#{__dirname}/fixtures/leaf-remainder.before.json", directory, _

  strata = new Strata directory: directory, leafSize: 3, branchSize: 3
  strata.open _

  cursor = strata.mutator "b", _
  index = cursor.insert "b", _
  cursor.unlock()

  records = []
  cursor = strata.iterator "a", _
  for i in [cursor.index...cursor.length]
    records.push cursor.get i, _
  cursor.unlock()

  @deepEqual records, [ "a", "b", "c", "d", "e", "f", "g", "h" ], "records"

  strata.balance _

  cursor = strata.iterator "a", _

  records = []
  loop
    for i in [cursor.index...cursor.length]
      records.push cursor.get i, _
    break unless cursor.next(_)
  cursor.unlock()

  @deepEqual records, [ "a", "b", "c", "d", "e", "f", "g", "h" ], "records after balance"

  expected = load "#{__dirname}/fixtures/leaf-remainder.after.json", _
  actual = objectify directory, _

  @deepEqual actual, expected, "split"
