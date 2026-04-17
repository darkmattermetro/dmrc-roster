class FormField {
  final String name;
  final String type;
  final bool required;
  final List<String> options;

  FormField({
    required this.name,
    required this.type,
    required this.required,
    required this.options,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      name: json['name'] ?? '',
      type: json['type'] ?? 'text',
      required: json['required'] ?? false,
      options: json['options'] != null 
          ? List<String>.from(json['options']) 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'required': required,
      'options': options,
    };
  }
}

class FormConfig {
  final int id;
  final String heading;
  final List<FormField> fields;
  final bool isActive;

  FormConfig({
    required this.id,
    required this.heading,
    required this.fields,
    required this.isActive,
  });

  factory FormConfig.fromJson(Map<String, dynamic> json) {
    return FormConfig(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      fields: json['fields'] != null 
          ? (json['fields'] as List)
              .map((f) => FormField.fromJson(f))
              .toList()
          : [],
      isActive: json['is_active'] ?? false,
    );
  }

  factory FormConfig.empty() {
    return FormConfig(id: 0, heading: '', fields: [], isActive: false);
  }
}

class FormResponse {
  final int id;
  final int formId;
  final String submittedBy;
  final String empNo;
  final Map<String, dynamic> data;
  final String status;
  final DateTime submittedAt;

  FormResponse({
    required this.id,
    required this.formId,
    required this.submittedBy,
    required this.empNo,
    required this.data,
    required this.status,
    required this.submittedAt,
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) {
    return FormResponse(
      id: json['id'] ?? 0,
      formId: json['form_id'] ?? 0,
      submittedBy: json['submitted_by'] ?? '',
      empNo: json['emp_no'] ?? '',
      data: json['data'] ?? {},
      status: json['status'] ?? 'Pending',
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at']) 
          : DateTime.now(),
    );
  }
}
