class Macroape::ComparesController < ::TasksController

protected
  def first_matrix_examples
    {
      pwm: Bioinform::PWM.new( File.read(Rails.root.join('public','motif_1.pwm')) ),
      pcm: Bioinform::PCM.new( File.read(Rails.root.join('public','motif_1.pcm')) ),
      ppm: Bioinform::PPM.new( File.read(Rails.root.join('public','motif_1.ppm')) )
    }
  end
  def second_matrix_examples
    {
      pwm: Bioinform::PWM.new( File.read(Rails.root.join('public','motif_2.pwm')) ),
      pcm: Bioinform::PCM.new( File.read(Rails.root.join('public','motif_2.pcm')) ),
      ppm: Bioinform::PPM.new( File.read(Rails.root.join('public','motif_2.ppm')) )
    }
  end
  helper_method :first_matrix_examples
  helper_method :second_matrix_examples
  def default_params
    { background_attributes: {mode: :wordwise, frequencies_attributes: [0.25, 0.25, 0.25, 0.25], gc_content: 0.5},
      pvalue: 0.0005,
      discretization: 10,
      pvalue_boundary: :upper,
      first_motif_attributes: {
        data_model: :PWM, effective_count: 100, pseudocount: nil,
        matrix: Bioinform::PWM.new( File.read(Rails.root.join('public','motif_1.pwm')) ).round(3)
      },
      second_motif_attributes: {
        data_model: :PWM, effective_count: 100, pseudocount: nil,
        matrix: Bioinform::PWM.new( File.read(Rails.root.join('public','motif_2.pwm')) ).round(3)
      }
    }
  end
end
