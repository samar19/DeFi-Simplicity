import { PropsWithChildren } from "react";

import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import Button from "@mui/material/Button";
import { Breakpoint } from "@mui/material";

interface ActionHandlerProps {
  label: string;
  actionHandler: () => void;
  disabled?: boolean;
}

interface ModalProps extends PropsWithChildren {
  open: boolean;
  setOpen: (open: boolean) => void;
  cancelProps?: ActionHandlerProps;
  disabled?: boolean;
  isLoading?: boolean;
  maxWidth?: Breakpoint;
  okProps?: ActionHandlerProps;
  title?: React.ReactNode;
  disableEscapeKeyDown?: boolean;
  disableBackdrop?: boolean;
}
export const Modal: React.FC<ModalProps> = ({
  open,
  setOpen,
  cancelProps,
  children,
  disabled,
  okProps,
  maxWidth = "sm",
  title,
  disableEscapeKeyDown,
  disableBackdrop,
}): JSX.Element => {
  const handleClose = (
    _event?: any,
    reason?: "escapeKeyDown" | "backdropClick" | undefined
  ) => {
    if (disableBackdrop && reason === "backdropClick") {
      return;
    } else if (disableEscapeKeyDown && reason === "escapeKeyDown") {
      return;
    }
    setOpen(false);
  };

  return (
    <Dialog
      fullWidth
      maxWidth={maxWidth}
      open={open}
      onClose={handleClose}
      disableEscapeKeyDown={disableEscapeKeyDown}
    >
      {title && <DialogTitle sx={{ paddingBottom: 0 }}>{title}</DialogTitle>}
      <DialogContent>{children}</DialogContent>
      <DialogActions>
        {cancelProps ? (
          <Button
            disabled={cancelProps?.disabled || disabled}
            variant="contained"
            color={"info"}
            onClick={cancelProps?.actionHandler || handleClose}
          >
            {cancelProps?.label || "Cancel"}
          </Button>
        ) : null}
        {okProps ? (
          <Button
            disabled={okProps.disabled || disabled}
            size="large"
            variant="contained"
            color={"info"}
            onClick={okProps.actionHandler}
          >
            {okProps.label}
          </Button>
        ) : null}
      </DialogActions>
    </Dialog>
  );
};

export default Modal;
