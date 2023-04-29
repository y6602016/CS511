	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 5: // STATE 3
		;
		now.flag[ Index(((P2 *)_this)->i, 2) ] = trpt->bup.oval;
		;
		goto R999;

	case 6: // STATE 4
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 10
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 8: // STATE 11
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 9: // STATE 13
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Q */

	case 10: // STATE 1
		;
		now.flag[ Index(((P1 *)_this)->me, 2) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		
	case 13: // STATE 11
		;
		now.turn = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 15: // STATE 16
		;
		now.c = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 17: // STATE 18
		;
		now.c = trpt->bup.oval;
		;
		goto R999;

	case 18: // STATE 19
		;
		now.flag[ Index(((P1 *)_this)->me, 2) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 20: // STATE 24
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC P */

	case 21: // STATE 1
		;
		now.flag[ Index(((P0 *)_this)->me, 2) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		
	case 24: // STATE 11
		;
		now.turn = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 26: // STATE 16
		;
		now.c = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 28: // STATE 18
		;
		now.c = trpt->bup.oval;
		;
		goto R999;

	case 29: // STATE 19
		;
		now.flag[ Index(((P0 *)_this)->me, 2) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 31: // STATE 24
		;
		p_restor(II);
		;
		;
		goto R999;
	}

