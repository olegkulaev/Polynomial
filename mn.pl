#!/usr/bin/perl -l

#making expression sorted and simple
sub multiply {
	$_ = shift;
	chomp;
	my %degree;
	$result=1+0;
	$result *= ($1+0) while (s/(?=[^\^]*)([0-9]+)//);
	$degree{"$1"} += $2 while (s/([a-zA-Z])\^\(?([0-9]+)\)?//);
	++$degree{"$1"} while (s/([a-zA-Z])(?=[^\^]?)//);
	@operands = sort keys %degree;
	$result.="*";
	foreach $key (@operands) {
		$result.="($key\^$degree{$key})";
	}
	return "$result";
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

#multiplying brackets (only with pluses =()
sub multiplyBrackets {
	($first,$second) = @_;
	@firstOperands = split /\+/,$first;
	@secondOperands = split /\+/,$second;
	my $result;
	foreach $first (@firstOperands) {
		print "first - $first";
		foreach $second (@secondOperands) {
			print "second - $second";
			$result.=multiply($first.$second).+"+";
		}
	}
	print $result;
}

#приводит подобные внутри одной скобки
#3a^7b^9+2a^7b^9 = 5*a^7b^9
sub sum {
	$input = shift;
	chomp $input;
	@operands = split /\+/,$input;
	my %result;
	foreach $operand (@operands) {
		$coef = $1 if $operand =~ s/^(\-?[0-9]+)//;
		if (!$result{$operand}) {
			$result{$operand} = $coef if $coef;
		} else {
			$result{$operand} += $coef if $coef;
		}
	}
	my $result;
	@operands = sort keys %result;
	foreach $operand (@operands) {
		$result.="$result{$operand}*$operand+";
	}
	chop $result;
	return $result;
}

print sum('112a^7b^9+-221a^7b^9+456b');