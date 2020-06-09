```yaml
development_dependencies:
  spec_codewars_formatter:
    github: codewars/crystal-spec-codewars-formatter
```

`spec/spec_helper.cr`
```crystal
require "spec"
require "spec_codewars_formatter"

Spec.override_default_formatter(CodewarsFormatter.new)
```
