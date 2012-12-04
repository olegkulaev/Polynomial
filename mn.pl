﻿#!/usr/bin/perl -l

#making expression sorted and simple
sub multiply {
	$_ = shift;
	chomp;
	@_ = split /\+/;
	my $return='';
	map {
		my %degree;
		$result=1+0;
		$result *= ($1+0) while (s/(?=[^\^]*)(\-?[0-9]+)//);
		$degree{"$1"} += $2 while (s/([a-zA-Z])\^\(?([0-9]+)\)?//);
		++$degree{"$1"} while (s/([a-zA-Z])(?=[^\^]?)//);
		@operands = sort keys %degree;
		$result.="*";
		foreach $key (@operands) {
			$result.="($key\^$degree{$key})";
		}
		$return.="${result}+";
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
	return $result;
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

#Заменяет все плюсы в строке на +-, нужно для корректной работы sum
sub prePlus {
	$_ = shift;
	s/\-/\+\-/;
	return $_;
}

sub standartPol {
	$input = shift;
	if ()
}
#test
# $first = 'b^5a^5+c^7*(a+b)'
# $second = 'a^5b^5+(a+b)*c^7'
$first = <>;
$second = <>;
chomp $first;
chomp $second;
print sum('112a^7b^9+-221a^7b^9+456b');
print multiply('-123aas+adsad');