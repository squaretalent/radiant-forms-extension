namespace :radiant do
  namespace :extensions do
    namespace :forms do
      
      desc "Runs the migration of the Forms extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FormsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FormsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Forms to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from FormerExtension"
        Dir[FormsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FormsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
