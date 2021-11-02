#!/bin/bash
#text = "\t\ttmpdir: "\/tmp\""

sed '
/shell-command: bash -lc/a\
\ \ \ \ \ \ \ \ tmpdir: "\/tmp\"
' spec/fixtures/litmus_inventory.yaml

