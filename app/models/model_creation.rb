require 'bioinform'

module Bioinform
  def self.get_model_class(data_model)
    Bioinform::MotifModel.const_get(data_model)
  end

  def self.get_model_from_string(data_model, matrix_string)
    get_model_class(data_model).from_string(matrix_string)
  end

  def self.get_pwm(data_model, matrix, background, pseudocount, effective_count)
    input_model = get_model_from_string(data_model, matrix)
    if Bioinform::MotifModel.acts_as_pwm?(input_model)
      input_model
    elsif Bioinform::MotifModel.acts_as_pcm?(input_model)
      pcm2pwm_converter = Bioinform::ConversionAlgorithms::PCM2PWMConverter.new(background: background, pseudocount: pseudocount)
      pcm2pwm_converter.convert(input_model)
    elsif Bioinform::MotifModel.acts_as_ppm?(input_model)
      ppm2pcm_converter = Bioinform::ConversionAlgorithms::PPM2PCMConverter.new(count: effective_count)
      pcm2pwm_converter = Bioinform::ConversionAlgorithms::PCM2PWMConverter.new(background: background, pseudocount: pseudocount)
      pcm2pwm_converter.convert(ppm2pcm_converter.convert(input_model))
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PWM creation failed (#{e})"
  end

  def self.get_pcm(data_model, matrix, effective_count)
    input_model = get_model_from_string(data_model, matrix)
    if Bioinform::MotifModel.acts_as_pcm?(input_model)
      input_model
    elsif Bioinform::MotifModel.acts_as_ppm?(input_model)
      ppm2pcm_converter = Bioinform::ConversionAlgorithms::PPM2PCMConverter.new(count: effective_count)
      ppm2pcm_converter.convert(input_model)
    elsif Bioinform::MotifModel.acts_as_pwm?(input_model)
      raise Error, 'Conversion PWM-->PCM not yet implemented'
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PCM creation failed (#{e})"
  end

  def self.get_ppm(data_model, matrix)
    input_model = get_model_from_string(data_model, matrix)
    if Bioinform::MotifModel.acts_as_ppm?(input_model)
      input_model
    elsif Bioinform::MotifModel.acts_as_pcm?(input_model)
      pcm2ppm_converter = Bioinform::ConversionAlgorithms::PCM2PPMConverter.new
      pcm2ppm_converter.convert(input_model)
    elsif Bioinform::MotifModel.acts_as_pwm?(input_model)
      raise Error, 'Conversion PWM-->PPM not yet implemented'
    else
      raise Error, "Unknown input `#{input_model}`"
    end
  rescue => e
    raise Error, "PPM creation failed (#{e})"
  end
end