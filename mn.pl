#!/usr/bin/perl -l


#making expression sorted and simple
sub multiply {
	$_ = shift;
	chomp;
	my %degree;
	$degree{"$1"} += $2 while (s/([a-zA-Z])\^\(?([0-9]+)\)?//);
	++$degree{"$1"} while (s/([a-zA-Z])(?=[^\^]?)//);
	@operands = sort keys %degree;
	my $result;
	foreach $key (@operands) {
		$result.="($key\^$degree{$key})";
	}
	return $result;
}

#"bool" func, check brackets
sub checkBrackets {
	my @stack;
	@input = split //,shift;
	map {
		if (/\(/) {
			push @stack,'(';
		} elsif(/\)/) {
			return 0 unless @stack;
			pop @stack;
		}
	}@input;
	@stack?return 0:return 1; 
}

#
sub multiplyBrackets {
	($first,$second) = @_;
	@firstOperands = split /\+/,$first;
	@secondOperands = split /\+/,$second;
	foreach $first (@firstOperands) {
		foreach $second (@secondOperands) {
			$result.=multiply($first.$second).+"+";
		}
	}
	print $result;
}
$input = <>;
chomp $input;
print multiply($input);

__END__
sub makeSimpleAndSorted {
	$input = shift @_;
	@operands = $input =~ /([a-zA-Z]\^\(?[0-9]+\)?)?/g;
	$input =~ s/[a-zA-Z]\^\([0-9]+\)?//g;
	my %output;
	map {	
		/([a-zA-Z]).\(?([0-9]+)/;
		$output{$1} += $2 if $2;
	}@operands;
	@operands = split//,$input;
	map {
		++$output{$_} if /[a-zA-Z]/;
	}@operands;
	@operands = sort keys %output;
	map {
		$output.="$_".'^'."($output{$_})" if /[a-zA-Z]/;
	}@operands;
	return $output;
}


sub checkBrackets {
	my @stack;
	@input = split //,shift;
	map {
		if (/\(/) {
			push @stack,'(';
		} elsif(/\)/) {
			return 0 unless @stack;
			pop @stack;
		}
	}@input;
	@stack?return 0:return 1; 
}


sub subsetInsideBracket{
	$input = shift;
	@sums = split /[+-]/,$input;
	print "@sums"." : sums";
	map {
		$input =~ s/($_)/makeSimpleAndSorted($1)/e;
	}@sums;
	return $input;
}
$first = <>;
chomp $first;
#print checkBrackets($first);
#print makeSimpleAndSorted($first);
print subsetInsideBracket($first);
