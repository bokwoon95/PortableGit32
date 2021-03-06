" ingo/buffer/scratch.vim: Functions for creating scratch buffers.
"
" DEPENDENCIES:
"   - ingo/buffer/generate.vim autoload script
"
" Copyright: (C) 2009-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! ingo#buffer#scratch#NextFilename( filespec )
    return ingo#buffer#generate#NextBracketedFilename(a:filespec, 'Scratch')
endfunction
function! ingo#buffer#scratch#Create( scratchDirspec, scratchFilename, scratchIsFile, scratchCommand, windowOpenCommand )
"*******************************************************************************
"* PURPOSE:
"   Create (or re-use an existing) scratch buffer (i.e. doesn't correspond to a
"   file on disk, but can be saved as such).
"   To keep the scratch buffer (and create a new scratch buffer on the next
"   invocation), rename the current scratch buffer via ':file <newname>', or
"   make it a normal buffer via ':setl buftype='.
"
"* ASSUMPTIONS / PRECONDITIONS:
"   None.
"* EFFECTS / POSTCONDITIONS:
"   Creates or opens scratch buffer and loads it in a window (as specified by
"   a:windowOpenCommand) and activates that window.
"* INPUTS:
"   a:scratchDirspec	Local working directory for the scratch buffer
"			(important for :! scratch commands). Pass empty string
"			to maintain the current CWD as-is. Pass '.' to maintain
"			the CWD but also fix it via :lcd.
"			(Attention: ':set autochdir' will reset any CWD once the
"			current window is left!) Pass the getcwd() output if
"			maintaining the current CWD is important for
"			a:scratchCommand.
"   a:scratchFilename	The name for the scratch buffer, so it can be saved via
"			either :w! or :w <newname>.
"   a:scratchIsFile	Flag whether the scratch buffer should behave like a
"			file (i.e. adapt to changes in the global CWD), or not.
"			If false and a:scratchDirspec is empty, there will be
"			only one scratch buffer with the same a:scratchFilename,
"			regardless of the scratch buffer's directory path.
"   a:scratchCommand	Ex command(s) to populate the scratch buffer, e.g.
"			":1read myfile". Use :1read so that the first empty line
"			will be kept (it is deleted automatically), and there
"			will be no trailing empty line.
"			Pass empty string if you want to populate the scratch
"			buffer yourself.
"			Pass a List of lines to set the scratch buffer contents
"			directly to the lines.
"   a:windowOpenCommand	Ex command to open the scratch window, e.g. :vnew or
"			:topleft new.
"* RETURN VALUES:
"   Indicator whether the scratch buffer has been opened:
"   0	Failed to open scratch buffer.
"   1	Already in scratch buffer window.
"   2	Jumped to open scratch buffer window.
"   3	Loaded existing scratch buffer in new window.
"   4	Created scratch buffer in new window.
"   Note: To handle errors caused by a:scratchCommand, you need to put this
"   method call into a try..catch block and :close the scratch buffer when an
"   exception is thrown.
"*******************************************************************************
    let l:status = ingo#buffer#generate#Create(a:scratchDirspec, a:scratchFilename, a:scratchIsFile, a:scratchCommand, a:windowOpenCommand, function('ingo#buffer#scratch#NextFilename'))
    if l:status != 0
	call ingo#buffer#scratch#SetLocal(a:scratchIsFile, ! empty(a:scratchCommand))
    endif
    return l:status
endfunction
function! ingo#buffer#scratch#SetLocal( isFile, isInitialized )
    execute 'setlocal buftype=' . ingo#buffer#generate#BufType(a:isFile)
    setlocal bufhidden=wipe nobuflisted noswapfile
    if a:isInitialized
	setlocal readonly
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
