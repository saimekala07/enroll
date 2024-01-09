// keyboard_navigation.js
function handleRadioKeyDown(event, radioId) {
  if (event.key === 'Enter') { 
    document.getElementById(radioId).click(); 
  }
}

function handleCitizenKeyDown(event, radioIdBase) {
  if (event.key === 'Enter') {
    const personElement = document.getElementById(`person_${radioIdBase}`);
    const dependentElement = document.getElementById(`dependent_${radioIdBase}`);

    if (personElement) {
      personElement.click();
    } else if (dependentElement) {
      dependentElement.click();
    }
  }
}

function handleButtonKeyDown(event, buttonId) {
  if (event.key === 'Enter') { 
    document.getElementById(buttonId).click(); 
  }
}

function handleCancelButtonKeyDown(event, buttonId, hideForm) {
  if (event.key === 'Enter') { 
    document.getElementById(buttonId).click(); 
    document.getElementById(hideForm).classList.add('hidden');
  }
}
