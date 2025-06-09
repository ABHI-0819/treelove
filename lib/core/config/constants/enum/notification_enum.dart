enum Not {
  success,
  message,
  warning,
  failed
}

extension NotString on Not {
  String str() {
    switch (this.index) {
      case 0:
        return 'Success';
        break;
      case 1:
        return 'Message';
        break;
      case 2:
        return 'Warning';
        break;
      default:
        return 'Failed';
    }
  }
}