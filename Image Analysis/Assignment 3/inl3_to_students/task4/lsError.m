function ls_error = lsError(xm,ym, p_ls)
% predicted line
y_predicted = p_ls(1) * xm + p_ls(2);

%vertical errors
vertical_error = ym - y_predicted;
ls_error = sum(vertical_error.^2);

end
