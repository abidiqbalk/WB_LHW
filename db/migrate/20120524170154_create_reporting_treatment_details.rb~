class CreateReportingTreatmentDetails < ActiveRecord::Migration
  def change
    create_table :reporting_treatment_details do |t|
      t.references:reporting_treatment
	  t.string:facility_code
	  t.integer:diarrhea_under5
      t.integer:diarrhea_under5_provided_med
      t.integer:diarrhea_over5
      t.integer:diarrhea_over5_provided_med
      t.integer:respiratory_disease_under5
      t.integer:respiratory_disease_under5_provided_med
      t.integer:respiratory_disease_over5
      t.integer:respiratory_disease_over5_provided_med
      t.integer:fever_under5
      t.integer:fever_under5_Provided_med
      t.integer:fever_over5
      t.integer:fever_over5_provided_med
      t.integer:anemia_under5
      t.integer:anemia_under5_provided_med
      t.integer:anemia_over5
      t.integer:anemia_over5_provided_med
      t.integer:referred_to_hf_under5
      t.integer:referred_to_hf_over5
      t.integer:eye_disease_weakness
      t.integer:eye_disease_red_eye
      t.integer:eye_disease_conjunctivitis
      t.integer:eye_disease_cataract
      t.integer:eye_disease_provided_med
      t.integer:eye_disease_referred
      t.integer:suspected_tb_cases
      t.integer:diagnosed_tb_cases
      t.integer:lhw_assisted_cases
      t.timestamps
    end
  end
end
