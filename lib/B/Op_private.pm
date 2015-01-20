# ex: set ro ft=c: -*- buffer-read-only: t -*-
#
#    lib/B/Op_private.pm
#
#    Copyright (C) 2014, 2015 by Larry Wall and others
#
#    You may distribute under the terms of either the GNU General Public
#    License or the Artistic License, as specified in the README file.
#
# !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
# This file is built by regen/opcode.pl from data in
# regen/op_private and pod embedded in regen/opcode.pl.
# Any changes made here will be lost!

=head1 NAME

B::Op_private -  OP op_private flag definitions

=head1 SYNOPSIS

    use B::Op_private;

    # flag details for bit 7 of OP_AELEM's op_private:
    my $name  = $B::Op_private::bits{aelem}{7}; # OPpLVAL_INTRO
    my $value = $B::Op_private::defines{$name}; # 128
    my $label = $B::Op_private::labels{$name};  # LVINTRO

    # the bit field at bits 5..6 of OP_AELEM's op_private:
    my $bf  = $B::Op_private::bits{aelem}{6};
    my $mask = $bf->{bitmask}; # etc

=head1 DESCRIPTION

This module provides four global hashes:

    %B::Op_private::bits
    %B::Op_private::defines
    %B::Op_private::labels
    %B::Op_private::ops_using

which contain information about the per-op meanings of the bits in the
op_private field.

=head2 C<%bits>

This is indexed by op name and then bit number (0..7). For single bit flags,
it returns the name of the define (if any) for that bit:

   $B::Op_private::bits{aelem}{7} eq 'OPpLVAL_INTRO';

For bit fields, it returns a hash ref containing details about the field.
The same reference will be returned for all bit positions that make
up the bit field; so for example these both return the same hash ref:

    $bitfield = $B::Op_private::bits{aelem}{5};
    $bitfield = $B::Op_private::bits{aelem}{6};

The general format of this hash ref is

    {
        # The bit range and mask; these are always present.
        bitmin        => 5,
        bitmax        => 6,
        bitmask       => 0x60,

        # (The remaining keys are optional)

        # The names of any defines that were requested:
        mask_def      => 'OPpFOO_MASK',
        baseshift_def => 'OPpFOO_SHIFT',
        bitcount_def  => 'OPpFOO_BITS',

        # If present, Concise etc will display the value with a 'FOO='
        # prefix. If it equals '-', then Concise will treat the bit
        # field as raw bits and not try to interpret it.
        label         => 'FOO',

        # If present, specifies the names of some defines and the
        # display labels that are used to assign meaning to particu-
        # lar integer values within the bit field; e.g. 3 is dis-
        # played as 'C'.
        enum          => [ qw(
                             1   OPpFOO_A  A
                             2   OPpFOO_B  B
                             3   OPpFOO_C  C
                         )],

    };


=head2 C<%defines>

This gives the value of every C<OPp> define, e.g.

    $B::Op_private::defines{OPpLVAL_INTRO} == 128;

=head2 C<%labels>

This gives the short display label for each define, as used by C<B::Concise>
and C<perl -Dx>, e.g.

    $B::Op_private::labels{OPpLVAL_INTRO} eq 'LVINTRO';

If the label equals '-', then Concise will treat the bit as a raw bit and
not try to display it symbolically.

=head2 C<%ops_using>

For each define, this gives a reference to an array of op names that use
the flag.

    @ops_using_lvintro = @{ $B::Op_private::ops_using{OPp_LVAL_INTRO} };

=cut

package B::Op_private;

our %bits;


our $VERSION = "5.022002";

$bits{$_}{3} = 'OPpENTERSUB_AMPER' for qw(entersub enterxssub rv2cv);
$bits{$_}{6} = 'OPpENTERSUB_DB' for qw(entersub enterxssub rv2cv);
$bits{$_}{2} = 'OPpENTERSUB_HASTARG' for qw(entersub enterxssub rv2cv);
$bits{$_}{0} = 'OPpENTERSUB_INARGS' for qw(entersub enterxssub);
$bits{$_}{6} = 'OPpFLIP_LINENUM' for qw(flip flop);
$bits{$_}{1} = 'OPpFT_ACCESS' for qw(fteexec fteread ftewrite ftrexec ftrread ftrwrite);
$bits{$_}{4} = 'OPpFT_AFTER_t' for qw(ftatime ftbinary ftblk ftchr ftctime ftdir fteexec fteowned fteread ftewrite ftfile ftis ftlink ftmtime ftpipe ftrexec ftrowned ftrread ftrwrite ftsgid ftsize ftsock ftsuid ftsvtx fttext fttty ftzero);
$bits{$_}{2} = 'OPpFT_STACKED' for qw(ftatime ftbinary ftblk ftchr ftctime ftdir fteexec fteowned fteread ftewrite ftfile ftis ftlink ftmtime ftpipe ftrexec ftrowned ftrread ftrwrite ftsgid ftsize ftsock ftsuid ftsvtx fttext fttty ftzero);
$bits{$_}{3} = 'OPpFT_STACKING' for qw(ftatime ftbinary ftblk ftchr ftctime ftdir fteexec fteowned fteread ftewrite ftfile ftis ftlink ftmtime ftpipe ftrexec ftrowned ftrread ftrwrite ftsgid ftsize ftsock ftsuid ftsvtx fttext fttty ftzero);
$bits{$_}{1} = 'OPpGREP_LEX' for qw(grepstart grepwhile mapstart mapwhile);
$bits{$_}{1} = 'OPpHINT_STRICT_REFS' for qw(entersub enterxssub multideref rv2av rv2cv rv2gv rv2hv rv2sv);
$bits{$_}{5} = 'OPpHUSH_VMSISH' for qw(dbstate nextstate);
$bits{$_}{2} = 'OPpITER_REVERSED' for qw(enteriter iter);
$bits{$_}{7} = 'OPpLVALUE' for qw(leave leaveloop);
$bits{$_}{6} = 'OPpLVAL_DEFER' for qw(aelem helem multideref);
$bits{$_}{7} = 'OPpLVAL_INTRO' for qw(aelem aslice cond_expr delete enteriter entersub enterxssub gvsv helem hslice list lvavref lvref lvrefslice multideref padav padhv padrange padsv pushmark refassign rv2av rv2gv rv2hv rv2sv);
$bits{$_}{2} = 'OPpLVREF_ELEM' for qw(lvref refassign);
$bits{$_}{3} = 'OPpLVREF_ITER' for qw(lvref refassign);
$bits{$_}{3} = 'OPpMAYBE_LVSUB' for qw(aassign aelem aelem_u aslice av2arylen helem hslice keys kvaslice kvhslice multideref padav padhv pos rkeys rv2av rv2gv rv2hv substr vec);
$bits{$_}{4} = 'OPpMAYBE_TRUEBOOL' for qw(padhv rv2hv);
$bits{$_}{7} = 'OPpOFFBYONE' for qw(caller runcv wantarray);
$bits{$_}{5} = 'OPpOPEN_IN_CRLF' for qw(backtick open);
$bits{$_}{4} = 'OPpOPEN_IN_RAW' for qw(backtick open);
$bits{$_}{7} = 'OPpOPEN_OUT_CRLF' for qw(backtick open);
$bits{$_}{6} = 'OPpOPEN_OUT_RAW' for qw(backtick open);
$bits{$_}{6} = 'OPpOUR_INTRO' for qw(enteriter gvsv rv2av rv2hv rv2sv split);
$bits{$_}{6} = 'OPpPAD_STATE' for qw(lvavref lvref padav padhv padsv pushmark refassign);
$bits{$_}{7} = 'OPpPV_IS_UTF8' for qw(dump goto last next redo);
$bits{$_}{6} = 'OPpREFCOUNTED' for qw(leave leaveeval leavesub leavesublv leavewrite);
$bits{$_}{6} = 'OPpRUNTIME' for qw(match pushre qr subst substcont);
$bits{$_}{2} = 'OPpSLICEWARNING' for qw(aslice hslice padav padhv rv2av rv2hv);
$bits{$_}{4} = 'OPpTARGET_MY' for qw(abs add atan2 chdir chmod chomp chown chr chroot concat cos crypt divide exec exp flock getpgrp getppid getpriority hex i_add i_bit_and i_bit_or i_bit_xor i_complement i_divide i_modulo i_multiply i_subtract index int kill left_shift length link log match mkdir modulo multiply oct ord pow push pushre qr rand rename right_shift rindex rmdir s_complement schomp setpgrp setpriority sin sleep sqrt srand stringify subst subtract symlink system time trans transr u_add u_multiply u_subtract unlink unshift utime wait waitpid);
$bits{$_}{5} = 'OPpTRANS_COMPLEMENT' for qw(trans transr);
$bits{$_}{7} = 'OPpTRANS_DELETE' for qw(trans transr);
$bits{$_}{0} = 'OPpTRANS_FROM_UTF' for qw(trans transr);
$bits{$_}{6} = 'OPpTRANS_GROWS' for qw(trans transr);
$bits{$_}{2} = 'OPpTRANS_IDENTICAL' for qw(trans transr);
$bits{$_}{3} = 'OPpTRANS_SQUASH' for qw(trans transr);
$bits{$_}{1} = 'OPpTRANS_TO_UTF' for qw(trans transr);
$bits{$_}{5} = 'OPpTRUEBOOL' for qw(padhv rv2hv);

my @bf = (
    {
        label     => '-',
        mask_def  => 'OPpARG1_MASK',
        bitmin    => 0,
        bitmax    => 0,
        bitmask   => 1,
    },
    {
        label     => '-',
        mask_def  => 'OPpARG2_MASK',
        bitmin    => 0,
        bitmax    => 1,
        bitmask   => 3,
    },
    {
        label     => '-',
        mask_def  => 'OPpARG3_MASK',
        bitmin    => 0,
        bitmax    => 2,
        bitmask   => 7,
    },
    {
        label     => '-',
        mask_def  => 'OPpARG4_MASK',
        bitmin    => 0,
        bitmax    => 3,
        bitmask   => 15,
    },
    {
        label     => '-',
        mask_def  => 'OPpPADRANGE_COUNTMASK',
        bitcount_def => 'OPpPADRANGE_COUNTSHIFT',
        bitmin    => 0,
        bitmax    => 6,
        bitmask   => 127,
    },
    {
        label     => '-',
        bitmin    => 0,
        bitmax    => 7,
        bitmask   => 255,
    },
    {
        mask_def  => 'OPpDEREF',
        bitmin    => 4,
        bitmax    => 5,
        bitmask   => 48,
        enum      => [
            1, 'OPpDEREF_AV', 'DREFAV',
            2, 'OPpDEREF_HV', 'DREFHV',
            3, 'OPpDEREF_SV', 'DREFSV',
        ],
    },
    {
        mask_def  => 'OPpLVREF_TYPE',
        bitmin    => 4,
        bitmax    => 5,
        bitmask   => 48,
        enum      => [
            0, 'OPpLVREF_SV', 'SV',
            1, 'OPpLVREF_AV', 'AV',
            2, 'OPpLVREF_HV', 'HV',
            3, 'OPpLVREF_CV', 'CV',
        ],
    },
);

@{$bits{aassign}}{6,1,0} = ('OPpASSIGN_COMMON', $bf[1], $bf[1]);
$bits{abs}{0} = $bf[0];
@{$bits{accept}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{add}}{1,0} = ($bf[1], $bf[1]);
$bits{aeach}{0} = $bf[0];
@{$bits{aelem}}{5,4,1,0} = ($bf[6], $bf[6], $bf[1], $bf[1]);
@{$bits{aelem_u}}{1,0} = ($bf[1], $bf[1]);
@{$bits{aelemfast}}{7,6,5,4,3,2,1,0} = ($bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5]);
@{$bits{aelemfast_lex}}{7,6,5,4,3,2,1,0} = ($bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5]);
@{$bits{aelemfast_lex_u}}{7,6,5,4,3,2,1,0} = ($bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5], $bf[5]);
$bits{akeys}{0} = $bf[0];
$bits{alarm}{0} = $bf[0];
$bits{and}{0} = $bf[0];
$bits{andassign}{0} = $bf[0];
$bits{anonconst}{0} = $bf[0];
@{$bits{anonhash}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{anonlist}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{atan2}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{av2arylen}{0} = $bf[0];
$bits{avalues}{0} = $bf[0];
$bits{backtick}{0} = $bf[0];
@{$bits{bind}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{binmode}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{bit_and}}{1,0} = ($bf[1], $bf[1]);
@{$bits{bit_or}}{1,0} = ($bf[1], $bf[1]);
@{$bits{bit_xor}}{1,0} = ($bf[1], $bf[1]);
@{$bits{bless}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{caller}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{chdir}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{chmod}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{chomp}{0} = $bf[0];
$bits{chop}{0} = $bf[0];
@{$bits{chown}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{chr}{0} = $bf[0];
$bits{chroot}{0} = $bf[0];
@{$bits{close}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{closedir}{0} = $bf[0];
@{$bits{cmp}}{1,0} = ($bf[1], $bf[1]);
$bits{complement}{0} = $bf[0];
@{$bits{concat}}{1,0} = ($bf[1], $bf[1]);
$bits{cond_expr}{0} = $bf[0];
@{$bits{connect}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{const}}{6,4,3,2,1} = ('OPpCONST_BARE', 'OPpCONST_ENTERED', 'OPpCONST_STRICT', 'OPpCONST_SHORTCIRCUIT', 'OPpCONST_NOVER');
@{$bits{coreargs}}{7,6,1,0} = ('OPpCOREARGS_PUSHMARK', 'OPpCOREARGS_SCALARMOD', 'OPpCOREARGS_DEREF2', 'OPpCOREARGS_DEREF1');
$bits{cos}{0} = $bf[0];
@{$bits{crypt}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{dbmclose}{0} = $bf[0];
@{$bits{dbmopen}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{defined}{0} = $bf[0];
@{$bits{delete}}{6,0} = ('OPpSLICE', $bf[0]);
@{$bits{die}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{divide}}{1,0} = ($bf[1], $bf[1]);
$bits{dofile}{0} = $bf[0];
$bits{dor}{0} = $bf[0];
$bits{dorassign}{0} = $bf[0];
$bits{dump}{0} = $bf[0];
$bits{each}{0} = $bf[0];
@{$bits{entereval}}{5,4,3,2,1,0} = ('OPpEVAL_RE_REPARSING', 'OPpEVAL_COPHH', 'OPpEVAL_BYTES', 'OPpEVAL_UNICODE', 'OPpEVAL_HAS_HH', $bf[0]);
$bits{entergiven}{0} = $bf[0];
$bits{enteriter}{3} = 'OPpITER_DEF';
@{$bits{entersub}}{5,4} = ($bf[6], $bf[6]);
$bits{entertry}{0} = $bf[0];
$bits{enterwhen}{0} = $bf[0];
@{$bits{enterwrite}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{enterxssub}}{5,4} = ($bf[6], $bf[6]);
@{$bits{eof}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{eq}}{1,0} = ($bf[1], $bf[1]);
@{$bits{exec}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{exists}}{6,0} = ('OPpEXISTS_SUB', $bf[0]);
@{$bits{exit}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{exp}{0} = $bf[0];
$bits{fc}{0} = $bf[0];
@{$bits{fcntl}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{fileno}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{flip}{0} = $bf[0];
@{$bits{flock}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{flop}{0} = $bf[0];
@{$bits{formline}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{ftatime}{0} = $bf[0];
$bits{ftbinary}{0} = $bf[0];
$bits{ftblk}{0} = $bf[0];
$bits{ftchr}{0} = $bf[0];
$bits{ftctime}{0} = $bf[0];
$bits{ftdir}{0} = $bf[0];
$bits{fteexec}{0} = $bf[0];
$bits{fteowned}{0} = $bf[0];
$bits{fteread}{0} = $bf[0];
$bits{ftewrite}{0} = $bf[0];
$bits{ftfile}{0} = $bf[0];
$bits{ftis}{0} = $bf[0];
$bits{ftlink}{0} = $bf[0];
$bits{ftmtime}{0} = $bf[0];
$bits{ftpipe}{0} = $bf[0];
$bits{ftrexec}{0} = $bf[0];
$bits{ftrowned}{0} = $bf[0];
$bits{ftrread}{0} = $bf[0];
$bits{ftrwrite}{0} = $bf[0];
$bits{ftsgid}{0} = $bf[0];
$bits{ftsize}{0} = $bf[0];
$bits{ftsock}{0} = $bf[0];
$bits{ftsuid}{0} = $bf[0];
$bits{ftsvtx}{0} = $bf[0];
$bits{fttext}{0} = $bf[0];
$bits{fttty}{0} = $bf[0];
$bits{ftzero}{0} = $bf[0];
@{$bits{ge}}{1,0} = ($bf[1], $bf[1]);
@{$bits{gelem}}{1,0} = ($bf[1], $bf[1]);
@{$bits{getc}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{getpeername}{0} = $bf[0];
@{$bits{getpgrp}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{getpriority}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{getsockname}{0} = $bf[0];
$bits{ggrgid}{0} = $bf[0];
$bits{ggrnam}{0} = $bf[0];
@{$bits{ghbyaddr}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{ghbyname}{0} = $bf[0];
@{$bits{glob}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{gmtime}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{gnbyaddr}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{gnbyname}{0} = $bf[0];
$bits{goto}{0} = $bf[0];
$bits{gpbyname}{0} = $bf[0];
@{$bits{gpbynumber}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{gpwnam}{0} = $bf[0];
$bits{gpwuid}{0} = $bf[0];
$bits{grepstart}{0} = $bf[0];
$bits{grepwhile}{0} = $bf[0];
@{$bits{gsbyname}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{gsbyport}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{gsockopt}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{gt}}{1,0} = ($bf[1], $bf[1]);
$bits{gv}{5} = 'OPpEARLY_CV';
@{$bits{helem}}{5,4,1,0} = ($bf[6], $bf[6], $bf[1], $bf[1]);
$bits{hex}{0} = $bf[0];
@{$bits{i_add}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_aelem}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_aelem_u}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_bit_and}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_bit_or}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_bit_xor}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_cmp}}{1,0} = ($bf[1], $bf[1]);
$bits{i_complement}{0} = $bf[0];
@{$bits{i_divide}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_eq}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_ge}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_gt}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_le}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_lt}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_modulo}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_multiply}}{1,0} = ($bf[1], $bf[1]);
@{$bits{i_ne}}{1,0} = ($bf[1], $bf[1]);
$bits{i_negate}{0} = $bf[0];
$bits{i_postdec}{0} = $bf[0];
$bits{i_postinc}{0} = $bf[0];
$bits{i_predec}{0} = $bf[0];
$bits{i_preinc}{0} = $bf[0];
@{$bits{i_subtract}}{1,0} = ($bf[1], $bf[1]);
@{$bits{index}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{int}{0} = $bf[0];
@{$bits{ioctl}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{join}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{keys}{0} = $bf[0];
@{$bits{kill}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{last}{0} = $bf[0];
$bits{lc}{0} = $bf[0];
$bits{lcfirst}{0} = $bf[0];
@{$bits{le}}{1,0} = ($bf[1], $bf[1]);
$bits{leaveeval}{0} = $bf[0];
$bits{leavegiven}{0} = $bf[0];
@{$bits{leaveloop}}{1,0} = ($bf[1], $bf[1]);
$bits{leavesub}{0} = $bf[0];
$bits{leavesublv}{0} = $bf[0];
$bits{leavewhen}{0} = $bf[0];
$bits{leavewrite}{0} = $bf[0];
@{$bits{left_shift}}{1,0} = ($bf[1], $bf[1]);
$bits{length}{0} = $bf[0];
@{$bits{link}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{list}{6} = 'OPpLIST_GUESSED';
@{$bits{listen}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{localtime}{0} = $bf[0];
$bits{lock}{0} = $bf[0];
$bits{log}{0} = $bf[0];
@{$bits{lslice}}{1,0} = ($bf[1], $bf[1]);
$bits{lstat}{0} = $bf[0];
@{$bits{lt}}{1,0} = ($bf[1], $bf[1]);
$bits{lvavref}{0} = $bf[0];
@{$bits{lvref}}{5,4,0} = ($bf[7], $bf[7], $bf[0]);
$bits{mapstart}{0} = $bf[0];
$bits{mapwhile}{0} = $bf[0];
$bits{method}{0} = $bf[0];
$bits{method_named}{0} = $bf[0];
$bits{method_redir}{0} = $bf[0];
$bits{method_redir_super}{0} = $bf[0];
$bits{method_super}{0} = $bf[0];
@{$bits{mkdir}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{modulo}}{1,0} = ($bf[1], $bf[1]);
@{$bits{msgctl}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{msgget}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{msgrcv}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{msgsnd}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{multideref}}{5,4,0} = ('OPpMULTIDEREF_DELETE', 'OPpMULTIDEREF_EXISTS', $bf[0]);
@{$bits{multiply}}{1,0} = ($bf[1], $bf[1]);
@{$bits{n_aelem}}{1,0} = ($bf[1], $bf[1]);
@{$bits{n_aelem_u}}{1,0} = ($bf[1], $bf[1]);
@{$bits{ne}}{1,0} = ($bf[1], $bf[1]);
$bits{negate}{0} = $bf[0];
$bits{next}{0} = $bf[0];
$bits{not}{0} = $bf[0];
$bits{oct}{0} = $bf[0];
$bits{once}{0} = $bf[0];
@{$bits{open}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{open_dir}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{or}{0} = $bf[0];
$bits{orassign}{0} = $bf[0];
$bits{ord}{0} = $bf[0];
@{$bits{pack}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{padrange}}{6,5,4,3,2,1,0} = ($bf[4], $bf[4], $bf[4], $bf[4], $bf[4], $bf[4], $bf[4]);
@{$bits{padsv}}{5,4} = ($bf[6], $bf[6]);
@{$bits{pipe_op}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{pop}{0} = $bf[0];
$bits{pos}{0} = $bf[0];
$bits{postdec}{0} = $bf[0];
$bits{postinc}{0} = $bf[0];
@{$bits{pow}}{1,0} = ($bf[1], $bf[1]);
$bits{predec}{0} = $bf[0];
$bits{preinc}{0} = $bf[0];
$bits{prototype}{0} = $bf[0];
@{$bits{push}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{quotemeta}{0} = $bf[0];
@{$bits{rand}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{range}{0} = $bf[0];
$bits{reach}{0} = $bf[0];
@{$bits{read}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{readdir}{0} = $bf[0];
$bits{readline}{0} = $bf[0];
$bits{readlink}{0} = $bf[0];
@{$bits{recv}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{redo}{0} = $bf[0];
$bits{ref}{0} = $bf[0];
@{$bits{refassign}}{5,4,1,0} = ($bf[7], $bf[7], $bf[1], $bf[1]);
$bits{refgen}{0} = $bf[0];
$bits{regcmaybe}{0} = $bf[0];
$bits{regcomp}{0} = $bf[0];
$bits{regcreset}{0} = $bf[0];
@{$bits{rename}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{repeat}}{6,1,0} = ('OPpREPEAT_DOLIST', $bf[1], $bf[1]);
$bits{require}{0} = $bf[0];
@{$bits{reset}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{reverse}}{3,0} = ('OPpREVERSE_INPLACE', $bf[0]);
$bits{rewinddir}{0} = $bf[0];
@{$bits{right_shift}}{1,0} = ($bf[1], $bf[1]);
@{$bits{rindex}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{rkeys}{0} = $bf[0];
$bits{rmdir}{0} = $bf[0];
$bits{rv2av}{0} = $bf[0];
@{$bits{rv2cv}}{7,5,0} = ('OPpENTERSUB_NOPAREN', 'OPpMAY_RETURN_CONSTANT', $bf[0]);
@{$bits{rv2gv}}{6,5,4,2,0} = ('OPpALLOW_FAKE', $bf[6], $bf[6], 'OPpDONT_INIT_GV', $bf[0]);
$bits{rv2hv}{0} = $bf[0];
@{$bits{rv2sv}}{5,4,0} = ($bf[6], $bf[6], $bf[0]);
$bits{rvalues}{0} = $bf[0];
@{$bits{s_aelem}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_aelem_u}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_bit_and}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_bit_or}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_bit_xor}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_cmp}}{1,0} = ($bf[1], $bf[1]);
$bits{s_complement}{0} = $bf[0];
@{$bits{s_eq}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_ge}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_gt}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_le}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_lt}}{1,0} = ($bf[1], $bf[1]);
@{$bits{s_ne}}{1,0} = ($bf[1], $bf[1]);
@{$bits{sassign}}{7,6,1,0} = ('OPpASSIGN_CV_TO_GV', 'OPpASSIGN_BACKWARDS', $bf[1], $bf[1]);
$bits{scalar}{0} = $bf[0];
$bits{schomp}{0} = $bf[0];
$bits{schop}{0} = $bf[0];
@{$bits{seek}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{seekdir}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{select}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{semctl}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{semget}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{semop}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{send}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{setpgrp}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{setpriority}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{shift}{0} = $bf[0];
@{$bits{shmctl}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{shmget}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{shmread}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{shmwrite}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{shostent}{0} = $bf[0];
@{$bits{shutdown}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{signature}{0} = $bf[0];
$bits{sin}{0} = $bf[0];
@{$bits{sleep}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{smartmatch}}{1,0} = ($bf[1], $bf[1]);
$bits{snetent}{0} = $bf[0];
@{$bits{socket}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{sockpair}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{sort}}{6,5,4,3,2,1,0} = ('OPpSORT_STABLE', 'OPpSORT_QSORT', 'OPpSORT_DESCEND', 'OPpSORT_INPLACE', 'OPpSORT_REVERSE', 'OPpSORT_INTEGER', 'OPpSORT_NUMERIC');
@{$bits{splice}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{split}{7} = 'OPpSPLIT_IMPLIM';
@{$bits{sprintf}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{sprotoent}{0} = $bf[0];
$bits{sqrt}{0} = $bf[0];
@{$bits{srand}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{srefgen}{0} = $bf[0];
@{$bits{sselect}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{sservent}{0} = $bf[0];
@{$bits{ssockopt}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{stat}{0} = $bf[0];
@{$bits{stringify}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{study}{0} = $bf[0];
$bits{substcont}{0} = $bf[0];
@{$bits{substr}}{4,2,1,0} = ('OPpSUBSTR_REPL_FIRST', $bf[2], $bf[2], $bf[2]);
@{$bits{subtract}}{1,0} = ($bf[1], $bf[1]);
@{$bits{symlink}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{syscall}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{sysopen}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{sysread}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{sysseek}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{system}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{syswrite}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{tell}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{telldir}{0} = $bf[0];
@{$bits{tie}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{tied}{0} = $bf[0];
@{$bits{truncate}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{u_add}}{1,0} = ($bf[1], $bf[1]);
@{$bits{u_multiply}}{1,0} = ($bf[1], $bf[1]);
@{$bits{u_subtract}}{1,0} = ($bf[1], $bf[1]);
$bits{uc}{0} = $bf[0];
$bits{ucfirst}{0} = $bf[0];
@{$bits{umask}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{undef}{0} = $bf[0];
@{$bits{unlink}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{unpack}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{unshift}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{untie}{0} = $bf[0];
@{$bits{utime}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
$bits{values}{0} = $bf[0];
@{$bits{vec}}{1,0} = ($bf[1], $bf[1]);
@{$bits{waitpid}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{warn}}{3,2,1,0} = ($bf[3], $bf[3], $bf[3], $bf[3]);
@{$bits{xor}}{1,0} = ($bf[1], $bf[1]);


our %defines = (
    OPpALLOW_FAKE            =>  64,
    OPpARG1_MASK             =>   1,
    OPpARG2_MASK             =>   3,
    OPpARG3_MASK             =>   7,
    OPpARG4_MASK             =>  15,
    OPpASSIGN_BACKWARDS      =>  64,
    OPpASSIGN_COMMON         =>  64,
    OPpASSIGN_CV_TO_GV       => 128,
    OPpCONST_BARE            =>  64,
    OPpCONST_ENTERED         =>  16,
    OPpCONST_NOVER           =>   2,
    OPpCONST_SHORTCIRCUIT    =>   4,
    OPpCONST_STRICT          =>   8,
    OPpCOREARGS_DEREF1       =>   1,
    OPpCOREARGS_DEREF2       =>   2,
    OPpCOREARGS_PUSHMARK     => 128,
    OPpCOREARGS_SCALARMOD    =>  64,
    OPpDEREF                 =>  48,
    OPpDEREF_AV              =>  16,
    OPpDEREF_HV              =>  32,
    OPpDEREF_SV              =>  48,
    OPpDONT_INIT_GV          =>   4,
    OPpEARLY_CV              =>  32,
    OPpENTERSUB_AMPER        =>   8,
    OPpENTERSUB_DB           =>  64,
    OPpENTERSUB_HASTARG      =>   4,
    OPpENTERSUB_INARGS       =>   1,
    OPpENTERSUB_NOPAREN      => 128,
    OPpEVAL_BYTES            =>   8,
    OPpEVAL_COPHH            =>  16,
    OPpEVAL_HAS_HH           =>   2,
    OPpEVAL_RE_REPARSING     =>  32,
    OPpEVAL_UNICODE          =>   4,
    OPpEXISTS_SUB            =>  64,
    OPpFLIP_LINENUM          =>  64,
    OPpFT_ACCESS             =>   2,
    OPpFT_AFTER_t            =>  16,
    OPpFT_STACKED            =>   4,
    OPpFT_STACKING           =>   8,
    OPpGREP_LEX              =>   2,
    OPpHINT_STRICT_REFS      =>   2,
    OPpHUSH_VMSISH           =>  32,
    OPpITER_DEF              =>   8,
    OPpITER_REVERSED         =>   4,
    OPpLIST_GUESSED          =>  64,
    OPpLVALUE                => 128,
    OPpLVAL_DEFER            =>  64,
    OPpLVAL_INTRO            => 128,
    OPpLVREF_AV              =>  16,
    OPpLVREF_CV              =>  48,
    OPpLVREF_ELEM            =>   4,
    OPpLVREF_HV              =>  32,
    OPpLVREF_ITER            =>   8,
    OPpLVREF_SV              =>   0,
    OPpLVREF_TYPE            =>  48,
    OPpMAYBE_LVSUB           =>   8,
    OPpMAYBE_TRUEBOOL        =>  16,
    OPpMAY_RETURN_CONSTANT   =>  32,
    OPpMULTIDEREF_DELETE     =>  32,
    OPpMULTIDEREF_EXISTS     =>  16,
    OPpOFFBYONE              => 128,
    OPpOPEN_IN_CRLF          =>  32,
    OPpOPEN_IN_RAW           =>  16,
    OPpOPEN_OUT_CRLF         => 128,
    OPpOPEN_OUT_RAW          =>  64,
    OPpOUR_INTRO             =>  64,
    OPpPADRANGE_COUNTMASK    => 127,
    OPpPADRANGE_COUNTSHIFT   =>   7,
    OPpPAD_STATE             =>  64,
    OPpPV_IS_UTF8            => 128,
    OPpREFCOUNTED            =>  64,
    OPpREPEAT_DOLIST         =>  64,
    OPpREVERSE_INPLACE       =>   8,
    OPpRUNTIME               =>  64,
    OPpSLICE                 =>  64,
    OPpSLICEWARNING          =>   4,
    OPpSORT_DESCEND          =>  16,
    OPpSORT_INPLACE          =>   8,
    OPpSORT_INTEGER          =>   2,
    OPpSORT_NUMERIC          =>   1,
    OPpSORT_QSORT            =>  32,
    OPpSORT_REVERSE          =>   4,
    OPpSORT_STABLE           =>  64,
    OPpSPLIT_IMPLIM          => 128,
    OPpSUBSTR_REPL_FIRST     =>  16,
    OPpTARGET_MY             =>  16,
    OPpTRANS_COMPLEMENT      =>  32,
    OPpTRANS_DELETE          => 128,
    OPpTRANS_FROM_UTF        =>   1,
    OPpTRANS_GROWS           =>  64,
    OPpTRANS_IDENTICAL       =>   4,
    OPpTRANS_SQUASH          =>   8,
    OPpTRANS_TO_UTF          =>   2,
    OPpTRUEBOOL              =>  32,
);

our %labels = (
    OPpALLOW_FAKE            => 'FAKE',
    OPpASSIGN_BACKWARDS      => 'BKWARD',
    OPpASSIGN_COMMON         => 'COMMON',
    OPpASSIGN_CV_TO_GV       => 'CV2GV',
    OPpCONST_BARE            => 'BARE',
    OPpCONST_ENTERED         => 'ENTERED',
    OPpCONST_NOVER           => 'NOVER',
    OPpCONST_SHORTCIRCUIT    => 'SHORT',
    OPpCONST_STRICT          => 'STRICT',
    OPpCOREARGS_DEREF1       => 'DEREF1',
    OPpCOREARGS_DEREF2       => 'DEREF2',
    OPpCOREARGS_PUSHMARK     => 'MARK',
    OPpCOREARGS_SCALARMOD    => '$MOD',
    OPpDEREF_AV              => 'DREFAV',
    OPpDEREF_HV              => 'DREFHV',
    OPpDEREF_SV              => 'DREFSV',
    OPpDONT_INIT_GV          => 'NOINIT',
    OPpEARLY_CV              => 'EARLYCV',
    OPpENTERSUB_AMPER        => 'AMPER',
    OPpENTERSUB_DB           => 'DBG',
    OPpENTERSUB_HASTARG      => 'TARG',
    OPpENTERSUB_INARGS       => 'INARGS',
    OPpENTERSUB_NOPAREN      => 'NO()',
    OPpEVAL_BYTES            => 'BYTES',
    OPpEVAL_COPHH            => 'COPHH',
    OPpEVAL_HAS_HH           => 'HAS_HH',
    OPpEVAL_RE_REPARSING     => 'REPARSE',
    OPpEVAL_UNICODE          => 'UNI',
    OPpEXISTS_SUB            => 'SUB',
    OPpFLIP_LINENUM          => 'LINENUM',
    OPpFT_ACCESS             => 'FTACCESS',
    OPpFT_AFTER_t            => 'FTAFTERt',
    OPpFT_STACKED            => 'FTSTACKED',
    OPpFT_STACKING           => 'FTSTACKING',
    OPpGREP_LEX              => 'GREPLEX',
    OPpHINT_STRICT_REFS      => 'STRICT',
    OPpHUSH_VMSISH           => 'HUSH',
    OPpITER_DEF              => 'DEF',
    OPpITER_REVERSED         => 'REVERSED',
    OPpLIST_GUESSED          => 'GUESSED',
    OPpLVALUE                => 'LV',
    OPpLVAL_DEFER            => 'LVDEFER',
    OPpLVAL_INTRO            => 'LVINTRO',
    OPpLVREF_AV              => 'AV',
    OPpLVREF_CV              => 'CV',
    OPpLVREF_ELEM            => 'ELEM',
    OPpLVREF_HV              => 'HV',
    OPpLVREF_ITER            => 'ITER',
    OPpLVREF_SV              => 'SV',
    OPpMAYBE_LVSUB           => 'LVSUB',
    OPpMAYBE_TRUEBOOL        => 'BOOL?',
    OPpMAY_RETURN_CONSTANT   => 'CONST',
    OPpMULTIDEREF_DELETE     => 'DELETE',
    OPpMULTIDEREF_EXISTS     => 'EXISTS',
    OPpOFFBYONE              => '+1',
    OPpOPEN_IN_CRLF          => 'INCR',
    OPpOPEN_IN_RAW           => 'INBIN',
    OPpOPEN_OUT_CRLF         => 'OUTCR',
    OPpOPEN_OUT_RAW          => 'OUTBIN',
    OPpOUR_INTRO             => 'OURINTR',
    OPpPAD_STATE             => 'STATE',
    OPpPV_IS_UTF8            => 'UTF',
    OPpREFCOUNTED            => 'REFC',
    OPpREPEAT_DOLIST         => 'DOLIST',
    OPpREVERSE_INPLACE       => 'INPLACE',
    OPpRUNTIME               => 'RTIME',
    OPpSLICE                 => 'SLICE',
    OPpSLICEWARNING          => 'SLICEWARN',
    OPpSORT_DESCEND          => 'DESC',
    OPpSORT_INPLACE          => 'INPLACE',
    OPpSORT_INTEGER          => 'INT',
    OPpSORT_NUMERIC          => 'NUM',
    OPpSORT_QSORT            => 'QSORT',
    OPpSORT_REVERSE          => 'REV',
    OPpSORT_STABLE           => 'STABLE',
    OPpSPLIT_IMPLIM          => 'IMPLIM',
    OPpSUBSTR_REPL_FIRST     => 'REPL1ST',
    OPpTARGET_MY             => 'TARGMY',
    OPpTRANS_COMPLEMENT      => 'COMPL',
    OPpTRANS_DELETE          => 'DEL',
    OPpTRANS_FROM_UTF        => '<UTF',
    OPpTRANS_GROWS           => 'GROWS',
    OPpTRANS_IDENTICAL       => 'IDENT',
    OPpTRANS_SQUASH          => 'SQUASH',
    OPpTRANS_TO_UTF          => '>UTF',
    OPpTRUEBOOL              => 'BOOL',
);


our %ops_using = (
    OPpALLOW_FAKE            => [qw(rv2gv)],
    OPpASSIGN_BACKWARDS      => [qw(sassign)],
    OPpASSIGN_COMMON         => [qw(aassign)],
    OPpCONST_BARE            => [qw(const)],
    OPpCOREARGS_DEREF1       => [qw(coreargs)],
    OPpEARLY_CV              => [qw(gv)],
    OPpENTERSUB_AMPER        => [qw(entersub enterxssub rv2cv)],
    OPpENTERSUB_INARGS       => [qw(entersub enterxssub)],
    OPpENTERSUB_NOPAREN      => [qw(rv2cv)],
    OPpEVAL_BYTES            => [qw(entereval)],
    OPpEXISTS_SUB            => [qw(exists)],
    OPpFLIP_LINENUM          => [qw(flip flop)],
    OPpFT_ACCESS             => [qw(fteexec fteread ftewrite ftrexec ftrread ftrwrite)],
    OPpFT_AFTER_t            => [qw(ftatime ftbinary ftblk ftchr ftctime ftdir fteexec fteowned fteread ftewrite ftfile ftis ftlink ftmtime ftpipe ftrexec ftrowned ftrread ftrwrite ftsgid ftsize ftsock ftsuid ftsvtx fttext fttty ftzero)],
    OPpGREP_LEX              => [qw(grepstart grepwhile mapstart mapwhile)],
    OPpHINT_STRICT_REFS      => [qw(entersub enterxssub multideref rv2av rv2cv rv2gv rv2hv rv2sv)],
    OPpHUSH_VMSISH           => [qw(dbstate nextstate)],
    OPpITER_DEF              => [qw(enteriter)],
    OPpITER_REVERSED         => [qw(enteriter iter)],
    OPpLIST_GUESSED          => [qw(list)],
    OPpLVALUE                => [qw(leave leaveloop)],
    OPpLVAL_DEFER            => [qw(aelem helem multideref)],
    OPpLVAL_INTRO            => [qw(aelem aslice cond_expr delete enteriter entersub enterxssub gvsv helem hslice list lvavref lvref lvrefslice multideref padav padhv padrange padsv pushmark refassign rv2av rv2gv rv2hv rv2sv)],
    OPpLVREF_ELEM            => [qw(lvref refassign)],
    OPpMAYBE_LVSUB           => [qw(aassign aelem aelem_u aslice av2arylen helem hslice keys kvaslice kvhslice multideref padav padhv pos rkeys rv2av rv2gv rv2hv substr vec)],
    OPpMAYBE_TRUEBOOL        => [qw(padhv rv2hv)],
    OPpMULTIDEREF_DELETE     => [qw(multideref)],
    OPpOFFBYONE              => [qw(caller runcv wantarray)],
    OPpOPEN_IN_CRLF          => [qw(backtick open)],
    OPpOUR_INTRO             => [qw(enteriter gvsv rv2av rv2hv rv2sv split)],
    OPpPAD_STATE             => [qw(lvavref lvref padav padhv padsv pushmark refassign)],
    OPpPV_IS_UTF8            => [qw(dump goto last next redo)],
    OPpREFCOUNTED            => [qw(leave leaveeval leavesub leavesublv leavewrite)],
    OPpREPEAT_DOLIST         => [qw(repeat)],
    OPpREVERSE_INPLACE       => [qw(reverse)],
    OPpRUNTIME               => [qw(match pushre qr subst substcont)],
    OPpSLICE                 => [qw(delete)],
    OPpSLICEWARNING          => [qw(aslice hslice padav padhv rv2av rv2hv)],
    OPpSORT_DESCEND          => [qw(sort)],
    OPpSPLIT_IMPLIM          => [qw(split)],
    OPpSUBSTR_REPL_FIRST     => [qw(substr)],
    OPpTARGET_MY             => [qw(abs add atan2 chdir chmod chomp chown chr chroot concat cos crypt divide exec exp flock getpgrp getppid getpriority hex i_add i_bit_and i_bit_or i_bit_xor i_complement i_divide i_modulo i_multiply i_subtract index int kill left_shift length link log match mkdir modulo multiply oct ord pow push pushre qr rand rename right_shift rindex rmdir s_complement schomp setpgrp setpriority sin sleep sqrt srand stringify subst subtract symlink system time trans transr u_add u_multiply u_subtract unlink unshift utime wait waitpid)],
    OPpTRANS_COMPLEMENT      => [qw(trans transr)],
);

$ops_using{OPpASSIGN_CV_TO_GV} = $ops_using{OPpASSIGN_BACKWARDS};
$ops_using{OPpCONST_ENTERED} = $ops_using{OPpCONST_BARE};
$ops_using{OPpCONST_NOVER} = $ops_using{OPpCONST_BARE};
$ops_using{OPpCONST_SHORTCIRCUIT} = $ops_using{OPpCONST_BARE};
$ops_using{OPpCONST_STRICT} = $ops_using{OPpCONST_BARE};
$ops_using{OPpCOREARGS_DEREF2} = $ops_using{OPpCOREARGS_DEREF1};
$ops_using{OPpCOREARGS_PUSHMARK} = $ops_using{OPpCOREARGS_DEREF1};
$ops_using{OPpCOREARGS_SCALARMOD} = $ops_using{OPpCOREARGS_DEREF1};
$ops_using{OPpDONT_INIT_GV} = $ops_using{OPpALLOW_FAKE};
$ops_using{OPpENTERSUB_DB} = $ops_using{OPpENTERSUB_AMPER};
$ops_using{OPpENTERSUB_HASTARG} = $ops_using{OPpENTERSUB_AMPER};
$ops_using{OPpEVAL_COPHH} = $ops_using{OPpEVAL_BYTES};
$ops_using{OPpEVAL_HAS_HH} = $ops_using{OPpEVAL_BYTES};
$ops_using{OPpEVAL_RE_REPARSING} = $ops_using{OPpEVAL_BYTES};
$ops_using{OPpEVAL_UNICODE} = $ops_using{OPpEVAL_BYTES};
$ops_using{OPpFT_STACKED} = $ops_using{OPpFT_AFTER_t};
$ops_using{OPpFT_STACKING} = $ops_using{OPpFT_AFTER_t};
$ops_using{OPpLVREF_ITER} = $ops_using{OPpLVREF_ELEM};
$ops_using{OPpMAY_RETURN_CONSTANT} = $ops_using{OPpENTERSUB_NOPAREN};
$ops_using{OPpMULTIDEREF_EXISTS} = $ops_using{OPpMULTIDEREF_DELETE};
$ops_using{OPpOPEN_IN_RAW} = $ops_using{OPpOPEN_IN_CRLF};
$ops_using{OPpOPEN_OUT_CRLF} = $ops_using{OPpOPEN_IN_CRLF};
$ops_using{OPpOPEN_OUT_RAW} = $ops_using{OPpOPEN_IN_CRLF};
$ops_using{OPpSORT_INPLACE} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpSORT_INTEGER} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpSORT_NUMERIC} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpSORT_QSORT} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpSORT_REVERSE} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpSORT_STABLE} = $ops_using{OPpSORT_DESCEND};
$ops_using{OPpTRANS_DELETE} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRANS_FROM_UTF} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRANS_GROWS} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRANS_IDENTICAL} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRANS_SQUASH} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRANS_TO_UTF} = $ops_using{OPpTRANS_COMPLEMENT};
$ops_using{OPpTRUEBOOL} = $ops_using{OPpMAYBE_TRUEBOOL};

# ex: set ro:
