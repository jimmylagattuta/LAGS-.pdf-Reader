class ReaderForPdfsController < ApplicationController

	def index
		require 'pdf-reader'
		@master_patient_list = []
		@temp_patient_list = []
		@text_message = "Results in your server log!"
		@count = 0
   		@criteria = []
		count = 0
		Dir.foreach("test_for_pdf") {|x| 
			new_path = "test_for_pdf/" + x
			if new_path.starts_with?('test_for_pdf/viewresults_4')
		    	File.open(new_path, "rb") do |io|
		    		@text = []
		      		reader = PDF::Reader.new(io)
		    		@page_one = []
		    		reader.pages.each_with_index do |page, index|
		    			if index == 0
			    			@patient = Hash.new
				    		page.text.each_line.with_index do |txt, index|
				    			# puts index.to_s + ". " + txt
				    			if index == 9
				    				splitter = txt.split(" ")
				    				name = splitter.third.to_s + " " + splitter.fourth.to_s
				    				@patient['Name'] = name
				    				@patient['Accession'] = splitter[-1]
				    			end
				    			if index == 11
				    				splitter = txt.split(" ")
				    				id = splitter.third
				    				@patient['Patient_ID'] = id
				    			end

				    			if index > 26
				    				if txt.starts_with?("Tramadol")
				    					splitter = txt.split(" ")
				    					amount = splitter.third
				    					@patient["Tramadol_HCL"] = amount
				    				end

				    				new_splitter = txt.split(" ")
				    				if new_splitter[-1] == "INCONSISTENT"
				    					drug = new_splitter.first
				    					if @patient["INCONSISTENT"] && @patient["INCONSISTENT_TWO"] && @patient["INCONSISTENT_THREE"] && @patient["INCONSISTENT_FOUR"]
				    						@patient["INCONSISTENT_FIVE"] = drug
				    					elsif @patient["INCONSISTENT"] && @patient["INCONSISTENT_TWO"] && @patient["INCONSISTENT_THREE"]
				    						@patient["INCONSISTENT_FOUR"] = drug
				    						
				    					elsif @patient["INCONSISTENT"] && @patient["INCONSISTENT_TWO"]
				    						@patient["INCONSISTENT_THREE"] = drug
				    					elsif @patient["INCONSISTENT"]
				    						@patient["INCONSISTENT_TWO"] = drug
				    					else
				    						@patient["INCONSISTENT"] =  drug
				    					end
				    				end
				    			end
		    				end
	    					@criteria << @patient
		    			end
		    		end
					puts "Count: " + " " + count.to_s
			    	count += 1

		    	end
	    	end
    	}

    	@criteria.each_with_index do |patient, index|
    		if patient['Tramadol_HCL'] == 'Negative'
    		else
    			puts index.to_s + ". ID: " + patient['Patient_ID'] + " Name: " + patient['Name'] + " Accession: " + patient['Accession']
    			puts "Tramadol: " + patient['Tramadol_HCL']
   		 		if patient['INCONSISTENT']
	    			puts "INCONSISTENCIES"
    				puts "INCONSISTENT ONE: " + patient["INCONSISTENT"]
    				if patient["INCONSISTENT_TWO"]
    					puts "INCONSISTENT_TWO: " + patient["INCONSISTENT_TWO"]
    					if patient["INCONSISTENT_THREE"]
    						puts "INCONSISTENT_THREE: " + patient["INCONSISTENT_THREE"]
    						if patient["INCONSISTENT_FOUR"]
    							puts "INCONSISTENT_FOUR: " + patient["INCONSISTENT_FOUR"]
    							if patient["INCONSISTENT_FIVE"] 
    								puts "INCONSISTENT_FIVE: " + patient["INCONSISTENT_FIVE"]
    							end
    						end
    					end
    				end
    			end
    		end
    	end

		render 'index.html.erb'





	end
end
