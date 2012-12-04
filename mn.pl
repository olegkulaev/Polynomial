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

#privodit podobnie (xz kak eto na angl, len' iskat')
#TODO:/ Нужно допилить эту функцию, то что написано бред
#я его писал в два часа ночи
sub sum {
	$_ = shift;
	@operands = split /\+/;
	my %result;
	foreach  $operand (@operand) {
		if ($result{$_}) {
			$result{$_} = multiply($result{$_}.$operand);
		} else {
			$result{$_} = $operand;
		}
	}
	@operand = sort keys %result;
}
multiplyBrackets('a+a+b','b+c');
