# gitlab_increate_swiftlint plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-gitlab_increate_swiftlint)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-gitlab_increate_swiftlint`, add it to your project by running:

```bash
fastlane add_plugin gitlab_increate_swiftlint
```

## About gitlab_increate_swiftlint

Incremental Code Check using swiftlint for swift language files on gitlab platform !

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```ruby
gitlab_increate_swiftlint(
  gitlab_host: 'https://xxx.com/api/v4',
  gitlab_token: 'xxxx',
  projectid: '16456',
  mrid: '33',
  lint_dir: '/Users/xiongzenghui/Desktop/ZHUDID',
  swiftlint_result_json: '/Users/xiongzenghui/Desktop/result.json',
  config_file: '/Users/xiongzenghui/Desktop/.swiftlint.yml'
)

pp Actions.lane_context[SharedValues::GITLAB_INCREATE_SWIFTLINT_RESULT_JSON]
```

得到如下的 json 数据

```json
[
  {
    "character": 13,
    "file": "/Users/xxx/ci-jenkins/workspace/xxx-iOS-module-xiongzenghui/ZHUDID/ZHUDID/Classes/Demo.swift",
    "line": 18,
    "reason": "Colons should be next to the identifier when specifying a type and next to the key in dictionary literals.",
    "rule_id": "colon",
    "severity": "Warning",
    "type": "Colon"
  },
  {
    "character": 28,
    "file": "/Users/xxx/ci-jenkins/workspace/xxx-iOS-module-xiongzenghui/ZHUDID/ZHUDID/Classes/Demo.swift",
    "line": 28,
    "reason": "Force casts should be avoided.",
    "rule_id": "force_cast",
    "severity": "Error",
    "type": "Force Cast"
  },
  {
    "character": 13,
    "file": "/Users/xxx/ci-jenkins/workspace/xxx-iOS-module-xiongzenghui/ZHUDID/ZHUDID/Classes/Haha.swift",
    "line": 18,
    "reason": "Colons should be next to the identifier when specifying a type and next to the key in dictionary literals.",
    "rule_id": "colon",
    "severity": "Warning",
    "type": "Colon"
  },
  {
    "character": 28,
    "file": "/Users/xxx/ci-jenkins/workspace/xxx-iOS-module-xiongzenghui/ZHUDID/ZHUDID/Classes/Haha.swift",
    "line": 28,
    "reason": "Force casts should be avoided.",
    "rule_id": "force_cast",
    "severity": "Error",
    "type": "Force Cast"
  }
]
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
