	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Q */

	case 3: // STATE 1
		;
		now.wantQ = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 5: // STATE 3
		;
		now.wantQ = trpt->bup.oval;
		;
		goto R999;

	case 6: // STATE 4
		;
		now.wantQ = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 10
		;
		now.wantQ = trpt->bup.oval;
		;
		goto R999;

	case 8: // STATE 14
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC P */

	case 9: // STATE 1
		;
		now.wantP = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 11: // STATE 3
		;
		now.wantP = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 4
		;
		now.wantP = trpt->bup.oval;
		;
		goto R999;

	case 13: // STATE 10
		;
		now.wantP = trpt->bup.oval;
		;
		goto R999;

	case 14: // STATE 14
		;
		p_restor(II);
		;
		;
		goto R999;
	}

