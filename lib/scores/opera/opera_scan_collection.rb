require 'yaml'
require 'ostruct'
task_params = OpenStruct.new(YAML.load_file('task_params.yaml'))
pvalue = task_params.pvalue
query_background_string = task_params.query_background ? "-b #{task_params.query_background.join(',')}" : ''
similarity_cutoff = task_params.similarity_cutoff
precise_recalc_cutoff = task_params.precise_recalc_cutoff
pvalue_boundary = task_params.pvalue_boundary

command = ["java -jar scan-collection.jar query.pwm collection --precalc collection_precalc",
            "-p #{pvalue}",
            "-c #{similarity_cutoff}",
            "--boundary #{pvalue_boundary}",
            "--precise #{precise_recalc_cutoff}",
            query_background_string,
            "--silent"
          ].join(' ')

if File.exist?('query.pcm')
  SMBSMCore.soloist('sequence_logo query.pcm', $ticket) # $ticket is defined in a wrapper (so on scene it's defined in a script)  
end

File.write('task_result.txt', SMBSMCore.soloist(command, $ticket))