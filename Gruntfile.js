module.exports = function(grunt) {
	// Project configuration.
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		
		coffee: {
			compile: {
				files: {
					'experiments/assets/javascripts/shurikend.js': 
					[
						'coffee/jquery-cookie.coffee',
						'coffee/jquery-event-move.coffee',
						'coffee/jquery-event-swipe.coffee',
						'coffee/jquery-offcanvas.coffee',
						'coffee/media-query-toggle.coffee',
						'coffee/jquery-placeholder.coffee',
						'coffee/alerts.coffee',
						'coffee/accordion.coffee', 
						'coffee/buttons.coffee',
						'coffee/tooltips.coffee',
						'coffee/forms.coffee',
						'coffee/tabs.coffee',
						'coffee/cursorup.coffee',
						'coffee/modal.coffee',
						'coffee/topbar.coffee',
						'coffee/nextstep.coffee',
						'coffee/magellan.coffee',
						'coffee/navigation.coffee',
						'coffee/slide.coffee',
						'coffee/app.coffee',
						// 'coffee/retina.coffee'
					] // compile and concat into single file
    			}
  			}
		},
	// Override setting in external config file
	compass: {
	    dist: {
	      options: {
	        config: 'config.rb',  // css_dir = 'dev/css'
	        cssDir: 'experiments/assets/css/',
			}
	      }
	     }
	});
	// Tasks
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-compass');
	grunt.registerTask('default', ['coffee', 'compass']);
}