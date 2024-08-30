function! CallAIRun(range, model, initial_prompt, temperature, prompt)
  let l:config = {
  \  "engine": "chat",
  \  "options": {
  \    "model": a:model,
  \    "initial_prompt": a:initial_prompt,
  \    "temperature": a:temperature,
  \  },
  \}
  echomsg string(l:config)
  call vim_ai#AIRun(a:range, l:config, a:prompt)
endfunction
