#!/usr/bin/perl

sub tag_authors_and_name {
	$_ = @_[0];

	# gets the authors before the '-' character and the music name
	if ($_ =~ /(.*)\s-\s(.*)(\(.*)/) {
		$first_authors = $1;
		$name = $2;
	} elsif ($_ =~ /(.*)\s-\s(.*)\.mp3/) {
		$first_authors = $1;
		$name = $2;
	}

	# gets the authors after the '-' character
	$last_authors = '';
	if ($_ =~ /.*\((.*)[Rr]emix.*/) {
		$last_authors = $1;
	}

	# makes a string with all authors separated by comma
	$authors = $first_authors . ' & ' . $last_authors;
	$word = '';
	@words = split(/\s+&\s+|\s*,\s+|\s+[Ff]eat\.?\s+|\s+[Ff][Tt]\.?\s+/, $authors);
	foreach $author (@words) {
		$word = $word . ', ' . $author;
	}
	$all_authors = join(', ', @words);

	# tags the music
	system("id3v2 -t \Q$name\E -a \Q$all_authors\E \Q@_[0]\E");
}


sub generate_info_file {
	open file, ">info.txt";
	foreach $music_name (@_) {
		if ($music_name =~ /(.*)\.mp3/) {
			print file "$1\tKind:\tAlbum:\tFaixa:\tData:\n";
		}
	}
	close file;
}


@files = <*>;
foreach $file (@files) {
	if ($file =~ /(.*)\.mp3/) {
		tag_authors_and_name($file);
	}
}
generate_info_file(@files);
