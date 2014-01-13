require 'yaml'
require 'ostruct'
task_params = OpenStruct.new(YAML.load_file('task_params.yaml'))

min_affinity_change = task_params.min_affinity_change
max_relevant_pvalue = task_params.max_relevant_pvalue

command = ["scan_collection query.pwm collection.yaml",
            "-p #{pvalue}",
            query_background_string,
            "-c #{similarity_cutoff}",
            "--boundary #{pvalue_boundary}",
            "--precise #{precise_recalc_cutoff}",
            "--silent"
          ].join(' ')

if File.exist?('query.pcm')
  SMBSMCore.soloist('sequence_logo query.pcm', $ticket) # $ticket is defined in a wrapper (so on scene it's defined in a script)
end

File.write('task_result.txt', SMBSMCore.soloist(command, $ticket))
