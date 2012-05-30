#!/usr/bin/perl -w

use strict;
use LWP::UserAgent;
use Data::Dumper ;
require HTTP::Cookies;
use HTML::Parser;
use HTML::Form;


#
# Globals
#
use vars qw/ @files $help $author $description /;

#
# Command line options processing
#
sub init()
{
        use Getopt::Long ;
        GetOptions(     
            "file|f=s{,}" 	  => \@files,
            "help|h" 	  => \$help,
    		"author|a=s" 	  => \$author,
    		"description|d=s" => \$description,
        );
        usage() if (!@files );
}

#
# Message about this program and how to use it
#
sub usage()
{
        print STDERR << "EOF";

This program upload file on http://demo.ovh.com

usage: $0 -f file [ file2 file3 ...]

--file /path/file  : file to upload
--author	   : author (optional)
--description      : description of the upload

example: $0 -f /tmp/foo /tmp/bar --author "John McLane" --description "my die hard"

EOF
        exit;
}

init();


my $ua  = LWP::UserAgent->new( 'agent' => "Mozilla/5.0" );
my $cookie = HTTP::Cookies->new();
$ua->cookie_jar( $cookie );

my $url = 'http://demo.ovh.com/';
my $res;


# first open get : 
#  set the cookie
#  start the session
#
$res = $ua->get($url);
if ($res->is_success) {
#       print $res->decoded_content."\n";  # or whatever
        print "open connection to demo.ovh.com\n";  # or whatever
}
else {
        die $res->status_line;
}

# second access : 
#  accept the disclamer
#  and go to next step
#
$res = $ua->post( $url,
           Content_Type => 'form-data',
           Content      => [
                'accept_disclamer'   => '1',
        		'step' 		     => '2',
           ]
  );

if ($res->is_success) 
{
#       print $res->decoded_content;  # or whatever
	print "demo.ovh.com : connected\n";
}
else 
{
        die $res->status_line;
}        


# prepare
#
my @upload_filename;

#
# send description and author
#
push @upload_filename, ( 'comment' => $description )
	if ( defined $description );

push @upload_filename, ( 'comment_author' => $author )
	if ( defined $author );



foreach my $f (@files)
{
	my %tmp = ( 'upload_filename'    =>  [$f] );
	push @upload_filename, %tmp ;
}

# send files
#
$res = $ua->post( $url,
           Content_Type => 'form-data',
           Content      => [
                'step'          => '3',
        		@upload_filename,
           ]
  );

# we get an 302 error, moved permanently, if it's ok
#
if (!$res->code() == 302)
{
	print Dumper $res ;
	die "upload failed \n";
}

# url is stock in localtion header
my $h = $res->headers();
print "url : ". $h->header( 'location' )."\n";

$url = $h->header( 'location' ) ;
# parse the new location
#
$res = $ua->get($url);
if ($res->is_success) {
    #  print $res->decoded_content."\n";  # or whatever
    my @split = split /</ , $res->decoded_content ;
    my @tab = grep { s/^a href=\"(\/download.*?)\">/file : http:\/\/demo.ovh.com$1/ } @split ;
    print "@tab\n";
}
else {
        die $res->status_line;
}


