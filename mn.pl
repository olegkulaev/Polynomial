#!/usr/bin/perl -l

#making expression sorted and simple
sub multiply {
	local $_ = shift;
	chomp;
	local @_ = split /\+/;
	my $return='';
	map {
		my %degree;
		local $result;
		#print;
		if (/^-|(-1)/) {
			$result = -1;
		} else {
			$result = 1;
		}
		$result *= ($2+0) while (s/([^\^]+|^)(\-?[0-9]+)/\1/);
		#print $2;
		$degree{"$1"} += $2 while (s/([a-zA-Z])\^\(?([0-9]+)\)?//);
		++$degree{"$1"} while (s/([a-zA-Z])(?=[^\^]?)//);
		@operands = sort keys %degree;
		$result.="*";
		foreach $key (@operands) {
			$result.="($key\^$degree{$key})";
		}
		$return.="${result}+";
		$result = 1+0;
	}@_;
	chop $return;
	return "$return";
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
	local ($first,$second) = @_;
	local @firstOperands = split /\+/,$first;
	local @secondOperands = split /\+/,$second;
	map {
		$_ = multiply($_);
		#print;
	}@firstOperands;
	map {
		$_ = multiply($_);
		#print;
	}@secondOperands;
	my $result;
	foreach $first (@firstOperands) {
		foreach $second (@secondOperands) {
			$result.=multiply($first.$second).+"+";
		}
	}
	return $result;
}

#приводит подобные внутри одной скобки
#3a^7b^9+2a^7b^9 = 5*a^7b^9
sub sum {
	local $input = shift;
	chomp $input;
	local @operands = split /\+/,$input;
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
		$result.="$result{$operand}$operand+";
	}
	chop $result;
	return $result;
}

#Заменяет все плюсы в строке на +-, нужно для корректной работы sum
sub prePlus {
	local $_ = shift;
	s/\-/\+\-/g;
	return $_;
}

sub standartPol {
	local $input = shift;
	$input = prePlus($input);
	#print $input;
	$input =~ s/\((.*?)\)\*?\((.*?)\)/multiplyBrackets($1,$2)/eg;
	#print $input;
	$input = multiply($input);
	#print $input;
	$input = sum($input);
	return $input;
	}
#test
$first = '(a+b)(c-d)';
$second = '(c-d)(a+b)';
#$second = '2c-N+2aabbac-aaabbN';
print $first = standartPol($first);
print $second = standartPol($second);
$first == $second?print 'equal':print 'non equal';