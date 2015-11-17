require 'csv_hasher'
require 'fileutils'

class UmovMeIntegration

   UMOVME_PEOPLE_FILENAME = 'PSA001_V2.csv'

   def build_people_file input_filename
      file = File.new(input_filename, "r")
      people_file_content = ""

      begin
	    people_file_content += build_people_header
	    people_file_content += build_people_content file 
		write_people_file people_file_content
		puts "File #{UMOVME_PEOPLE_FILENAME} generated!!"
	  
	  rescue => err
	  	puts err
	    puts 'error while generating people file'
	  
	  end
   end

   def build_people_content file
   	  people_content = ""
   	  while (line = file.gets)
	    	csv = CSV.parse(line, :col_sep => ?;, headers: false)
			csv.each do |line|
				people_content += build_insert_command line
			end
	    end
	  people_content
   end

   def build_people_header
   	  header = "C\n"
	  header += "command;name;login;password;alternativeIdentifier;agentType\n"
	  header
   end

   def build_insert_command csv_line
      nome = csv_line[1]
	  login = csv_line[0]
	  password = csv_line[0].split('@')[0]
	  alternative_identifier = login
	  people_insert_command = "I;#{nome};#{login};#{password};#{alternative_identifier};inscritos\n"
	  people_insert_command 
   end

   def write_people_file content_file
   	  File.write(UMOVME_PEOPLE_FILENAME, content_file)
   end

end

umovme_integration = UmovMeIntegration.new
umovme_integration.build_people_file 'Gerenciar_participantes.csv'
