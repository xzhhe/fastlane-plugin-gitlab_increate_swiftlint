require 'fastlane/action'
require_relative '../helper/gitlab_increate_swiftlint_helper'

module Fastlane
  module Actions
    module SharedValues
      GITLAB_INCREATE_SWIFTLINT_RESULT_JSON = :GITLAB_INCREATE_SWIFTLINT_RESULT_JSON
      # GITLAB_INCREATE_SWIFTLINT_INTERVAL_JSON = :GITLAB_INCREATE_SWIFTLINT_INTERVAL_JSON
    end
    
    class GitlabIncreateSwiftlintAction < Action
      def self.run(params)
        require 'pp'
        require 'json'
        require 'gitlab'

        gitlab_host = params[:gitlab_host]
        gitlab_token = params[:gitlab_token]
        projectid = params[:projectid]
        mrid = params[:mrid]
        lint_dir = params[:lint_dir]
        swiftlint_result_json = params[:swiftlint_result_json]
        config_file = params[:config_file]

        # begin_time = Time.new

        # 1. 得到 MR 变动的 文件 list
        gc = Gitlab.client(endpoint: gitlab_host, private_token: gitlab_token)
        mr_hash = gc.merge_request_changes(projectid, mrid).to_hash
        changes_file_paths = mr_hash['changes'].map { |c|
          c['new_path'] #=> 始终使用【当前最新】文件路径
        }
        UI.success('[GitlabIncreateSwiftlintAction] get merge_request_changes ✅')
        pp changes_file_paths

        # 2. 过滤只对 *.swift 进行 lint
        swift_files = changes_file_paths.select do |file|
          file =~ /.swift$/
        end
        pp swift_files
        return true if swift_files.empty?

        # 3. 拼接 swiftlint command
        #
        # SCRIPT_INPUT_FILE_COUNT=2 \
        # SCRIPT_INPUT_FILE_0=Classes/Answer/Views/AnswerHybridContainer.swift \
        # SCRIPT_INPUT_FILE_1=Classes/Invite/View/InviteeUserListViewCell.swift \
        # swiftlint lint \
        # --reporter json \
        # --quiet \
        # --use-script-input-files \
        # > swiftlint.result.json
        #
        cmd = "SCRIPT_INPUT_FILE_COUNT=#{swift_files.count} "
        swift_files.each_with_index do |ite, idx|
          # - lint_dir: git clone git@xxx.com:user/pod.git /path/to/pod
          # - ite: Class/aa/bb/xx.swift
          # - filepath = #{lint_dir}/#{ite}
          filepath = File.expand_path(ite, lint_dir)
          cmd << "SCRIPT_INPUT_FILE_#{idx}=#{filepath} "
        end

        if config_file
          cmd << "swiftlint lint --reporter json --quiet --config #{config_file} --use-script-input-files "
        else
          cmd << "swiftlint lint --reporter json --quiet --use-script-input-files "
        end
        cmd << "> #{swiftlint_result_json} " if swiftlint_result_json
        UI.message("[GitlabIncreateSwiftlintAction] sh: #{cmd} ⚠️")
        # Actions.sh(cmd) #=> swiftlitn 返回 2 , 而不是 0 , 会导致 fastlane action 判断为执行【失败】
        rt = system(cmd)

        # 4.
        ajson = File.read(swiftlint_result_json)
        Actions.lane_context[SharedValues::GITLAB_INCREATE_SWIFTLINT_RESULT_JSON] = JSON.parse(ajson)

        # 5.
        # end_time = Time.new
        # interval_diff = (end_time - begin_time).to_i
        # swiftlint_result = {
        #   interval_diff: interval_diff
        # }
        # File.open(swiftlint_result_others_json, 'w') do |f|
        #   f.write(swiftlint_result.to_json)
        # end
        # Actions.lane_context[SharedValues::SWIFTLINT_POD_RESULT_INTERVAL_JSON] = swiftlint_result

        rt
      end

      def self.description
        "Incremental Code Check using swiftlint for swift language files on gitlab platform !"
      end

      def self.authors
        ["xiongzenghui"]
      end

      def self.return_value
        'boolean return true is success, otherwaise false is error'
      end

      def self.output
        [
          ['GITLAB_INCREATE_SWIFTLINT_RESULT_JSON', 'swiftlint lint result json']
        ]
      end

      def self.details
        "Incremental Code Check using swiftlint for swift language files on gitlab platform !"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :gitlab_host,
            description: "your gitlab host"
          ),
          FastlaneCore::ConfigItem.new(
            key: :gitlab_token,
            description: "your gitlab token"
          ),
          FastlaneCore::ConfigItem.new(
            key: :projectid,
            description: "your gitlab project id"
          ),
          FastlaneCore::ConfigItem.new(
            key: :mrid,
            description: "your gitlab merge request id"
          ),
          FastlaneCore::ConfigItem.new(
            key: :lint_dir,
            description: "where your pod dir"
          ),
          FastlaneCore::ConfigItem.new(
            key: :swiftlint_result_json,
            description: "where save swiftlint report json file",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :config_file,
            description: "if you pass your custom .swiftlint.yml rule file",
            optional: true
          )
        ]
      end

      def self.example_code
        [
          'gitlab_increate_swiftlint(
            gitlab_host: "https://xxx.com/api/v4",
            gitlab_token: "xxxx",
            projectid: "16456",
            mrid: "33",
            lint_dir: "/Users/xiongzenghui/Desktop/AFNetworking",
            swiftlint_result_json: "/Users/xiongzenghui/Desktop/result.json",
            config_file: "/Users/xiongzenghui/Desktop/.swiftlint.yml"
          )
          pp Actions.lane_context[SharedValues::GITLAB_INCREATE_SWIFTLINT_RESULT_JSON]'
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
