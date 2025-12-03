BEGIN {
    header_content = ""
    login_patterns = "(sid=|uid=|user=|pass=|email=|login=|token=|session=|username=|password=)[^&]*"
}

/POST \// {
    post_header = 1
}

post_header == 1 {
    header_line = $0
    if (header_line ~ /^[[:space:]]*$/) {
        post_header = 0
        post_body = 1
        next
    } else {
        header_content = (header_content != "") ? header_content "\n" : header_content
        header_content = header_content header_line
    }
}

post_body == 1 {
    body_line = $0
    if (body_line ~ login_patterns) {
        print header_content
        print body_line
    }
    post_body = 0
    header_content = ""
}
