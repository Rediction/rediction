module FormBuildHelper
  def base_form_for(name, *args, &block)
    options = args.extract_options!
    args << options.merge(builder: BaseFormBuilder)
    form_for(name, *args, &block)
  end
end
