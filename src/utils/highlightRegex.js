export function highlightBySelectedOption(
  str,
  selectedOption,
  className = "highlight"
) {
  let regex;

  switch (selectedOption) {
    case "parantheses":
      regex = /\([^)]*\)/g;
      break;
    case "apostrophe":
      regex = /['’]/g;
      break;
    case "comma":
      regex = /,/g;
      break;
    case "period":
      regex = /\./g;
      break;
    case "exclamation":
      regex = /!/g;
      break;
    case "question":
      regex = /\?/g;
      break;
    case "slash":
      regex = /[\/\\]/g;
      break;
    case "dash":
      regex = /[-–—]/g;
      break;
    case "ellipses":
      regex = /(\.\.\.|…)/g;
      break;
    case "colons":
      regex = /:/g;
      break;
    case "quote":
      regex = /["“”]/g;
      break;
    case "asterisk":
      regex = /\*/g;
      break;
    case "ampersand":
      regex = /&/g;
      break;
    default:
      return str; // no match — return as-is
  }

  return str.replace(
    regex,
    (match) => `<span class="${className}">${match}</span>`
  );
}
