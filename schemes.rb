require 'json'
require 'handlebars'
require 'fileutils'

# Iterate theme files.
Dir['themes/*.json', 'themes/*/*.json'].each do |theme|


    # Load the theme file.
    theme = IO.read theme

    # Parse the theme file as JSON.
    theme = JSON.parse theme

    # Insert the current year for copyrights.
    theme['year'] = Time.now.year

    # Output current theme being processed.
    puts "THEME: " + theme['theme']['name']

    # Iterate pattern files.
    Dir['patterns/*/*.pattern'].each do |pattern|

        # Load the template file.
        template = IO.read pattern

        # Read the associated pattern config file.
        config = IO.read pattern.sub('.pattern', '.json')

        # Parse the config file as JSON.
        config = JSON.parse config

        # Output current format being processed.
        puts "\t- " + config['type']


        # Create a new handlebars instance.
        handlebars = Handlebars::Context.new

        # Apply the pattern template to the handlebars instance.
        template = handlebars.compile template

        # Build the output path.
        path = 'output/' + config['folder'] + '/'

        # Option for subfolders.
        path << theme['theme']['dir']+'/' if theme['theme']['dir']

        # Create the output directory.
        FileUtils.mkpath(path)

        # Build the file path.
        filename = path + theme['theme']['slug']+config['extension']

        # Write the file.
        File.open(filename, 'w').write template.call theme
    end
end
