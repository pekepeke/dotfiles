#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup
require 'erubis'

set :erubis, :escape_html => true
enable :sessions, :logging
set :public_folder, File.dirname(__FILE__) + "/public"

configure :production do
  disable :dump_errors
end
configure :development do
end
configure :test do
end

helpers do
  include Rack::Utils
  alias :escape_html :h
end

before do
  # 
end
after do
  #
end

get '/' do
  erubis :index
end
if __FILE__ == $0
end


@@index
<h1></h1>
<p></p>

@@layout
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">
		<meta name="robots" content="noindex, nofollow"/>
		<!-- 
		<link rel="stylesheet" media="screen" href="reset.css" />
		<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1, minimum-scale=0.5 , maximum-scale=2">
		<link rel="stylesheet" media="screen and (max-width: 65025px)" href="style.css" />
		<link rel="stylesheet" media="screen and (max-width: 640px)" href="mobile.css" />
		-->

		<!-- Le styles -->
		<link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">
		<style>
			body {
				padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
			}
		</style>
		<link href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" rel="stylesheet">

		<!-- Le javascript
		================================================== -->

		<script src="http://www.google.com/jsapi"></script>
		<script>//<![[CDATA[
			google.load("jquery", "1.7.1");
			google.load("jqueryui", "1.8.16");
			//]]></script>
		<!-- Placed at the end of the document so the pages load faster -->
		<!-- <script src="http://twitter.github.com/bootstrap/assets/js/jquery.js"></script> -->
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-transition.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-alert.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-modal.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-dropdown.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-scrollspy.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-tab.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-tooltip.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-popover.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-button.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-collapse.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-carousel.js"></script>
		<script src="http://twitter.github.com/bootstrap/assets/js/bootstrap-typeahead.js"></script>

		<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
		<!--[if lt IE 9]>
		<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<script src="//css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
		<![endif]-->
		<script>//<![[CDATA[
			!function($, Global) {
			}(jQuery, this);
//]]></script>

		<!-- Le fav and touch icons -->
		<!--
		<link rel="shortcut icon" href="images/favicon.ico">
		<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
		<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
		<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
		-->
	</head>
	<body>
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container">
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</a>
					<a class="brand" href="#">Name</a>
					<div class="nav-collapse">
						<ul class="nav">
							<li class="active"><a href="#">Home</a></li>
							<li><a href="#about">About</a></li>
							<li><a href="#contact">Contact</a></li>
						</ul>
					</div><!--/.nav-collapse -->
				</div>
			</div>
		</div>

		<div class="container">

      <%== yield %>

		</div> <!-- /container -->
	</body>
</html>
