enum Status {
  pending,
  assigned,
  inProgress,
  done,
}

extension StatusString on Status {
  String str() {
    switch (index) {
      case 0:
        return 'Pending';
      case 1:
        return 'Assigned';
      case 2:
        return 'In Progress';
      case 3:
        return 'Done';
      default:
        return '';
    }
  }

  String apiValue() {
    switch (index) {
      case 0:
        return 'pending';
      case 1:
        return 'assigned';
      case 2:
        return 'in_progress';
      case 3:
        return 'done';
      default:
        return '';
    }
  }

  static Status fromApi(String value) {
    switch (value) {
      case 'pending':
        return Status.pending;
      case 'assigned':
        return Status.assigned;
      case 'in_progress':
        return Status.inProgress;
      case 'done':
        return Status.done;
      default:
        return Status.pending; // fallback
    }
  }
}
