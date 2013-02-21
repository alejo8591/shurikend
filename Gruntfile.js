module.exports = function(grunt) {
	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		
		coffee: {
			compile: {
				files: {
					'test/assets/javascripts/shurikend.js': 
					[
						'coffee/mediaQueryToggle.coffee',
						'coffee/jquery-placeholder.coffee',
						'coffee/alerts.coffee',
						'coffee/accordion.coffee', 
						'coffee/buttons.coffee',
						'coffee/tooltips.coffee',
						'coffee/forms.coffee',
						'coffee/tabs.coffee',
						'coffee/navigation.coffee',
						'coffee/modal.coffee',
						'coffee/orbit.coffee',
						'coffee/topbar.coffee',
						'coffee/jquery-cookie.coffee',
						'coffee/joyride.coffee',
						'coffee/clearing.coffee',
						'coffee/jquery-event-move.coffee',
						'coffee/jquery-event-swipe.coffee',
						'coffee/jquery-offcanvas.coffee',
						'coffee/magellan.coffee',
						'coffee/app.coffee'
					] // compile and concat into single file
    			}
  			}
		},
	// Override setting in external config file
	compass: {
	    dist: {
	      options: {
	        config: 'config.rb',  // css_dir = 'dev/css'
	        cssDir: 'test/assets/css/',
			}
	      }
	     }
	});
	// Tasks
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-compass');
	grunt.registerTask('default', ['coffee', 'compass']);
}